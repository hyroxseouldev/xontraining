import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

const _avatarMarker = '/storage/v1/object/public/avatars/';

Future<void> main(List<String> args) async {
  final dryRun = args.contains('--dry-run');
  final deleteOld = args.contains('--delete-old');

  final supabaseUrl = _requireEnv('SUPABASE_URL');
  final serviceRoleKey = _requireEnv('SUPABASE_SERVICE_ROLE_KEY');

  final client = HttpClient();
  try {
    final rows = await _fetchTenantProfiles(
      client: client,
      supabaseUrl: supabaseUrl,
      serviceRoleKey: serviceRoleKey,
    );

    final legacyRows = rows
        .where((row) {
          final avatarUrl = row['avatar_url'];
          return avatarUrl is String && avatarUrl.contains('avatars/users/');
        })
        .toList(growable: false);

    stdout.writeln('Found ${legacyRows.length} legacy avatar rows.');

    for (final row in legacyRows) {
      final tenantId = row['tenant_id'] as String?;
      final userId = row['user_id'] as String?;
      final avatarUrl = row['avatar_url'] as String?;
      if (tenantId == null || userId == null || avatarUrl == null) {
        continue;
      }

      final oldPath = _extractStoragePath(avatarUrl);
      if (oldPath == null) {
        continue;
      }

      final filename = oldPath.split('/').last;
      final newPath = 'tenants/$tenantId/users/$userId/$filename';
      final newUrl = '$supabaseUrl$_avatarMarker$newPath';

      stdout.writeln('Migrating $oldPath -> $newPath');
      if (dryRun) {
        continue;
      }

      final download = await _downloadBytes(client, avatarUrl);
      await _uploadAvatar(
        client: client,
        supabaseUrl: supabaseUrl,
        serviceRoleKey: serviceRoleKey,
        path: newPath,
        bytes: download.bytes,
        contentType: download.contentType,
      );
      await _updateAvatarUrl(
        client: client,
        supabaseUrl: supabaseUrl,
        serviceRoleKey: serviceRoleKey,
        tenantId: tenantId,
        userId: userId,
        avatarUrl: newUrl,
      );

      if (deleteOld) {
        await _deleteAvatar(
          client: client,
          supabaseUrl: supabaseUrl,
          serviceRoleKey: serviceRoleKey,
          path: oldPath,
        );
      }
    }
  } finally {
    client.close(force: true);
  }
}

String _requireEnv(String name) {
  final value = Platform.environment[name]?.trim();
  if (value == null || value.isEmpty) {
    throw StateError('$name is required.');
  }
  return value;
}

Future<List<Map<String, dynamic>>> _fetchTenantProfiles({
  required HttpClient client,
  required String supabaseUrl,
  required String serviceRoleKey,
}) async {
  final uri = Uri.parse(
    '$supabaseUrl/rest/v1/tenant_user_profiles?select=tenant_id,user_id,avatar_url',
  );
  final request = await client.getUrl(uri);
  _applySupabaseHeaders(request, serviceRoleKey);
  request.headers.set(HttpHeaders.acceptHeader, 'application/json');

  final response = await request.close();
  final body = await utf8.decodeStream(response);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw HttpException(
      'Failed to fetch tenant profiles: ${response.statusCode} $body',
    );
  }

  final decoded = jsonDecode(body) as List<dynamic>;
  return decoded.cast<Map<String, dynamic>>();
}

Future<_DownloadResult> _downloadBytes(HttpClient client, String url) async {
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();
  if (response.statusCode < 200 || response.statusCode >= 300) {
    final body = await utf8.decodeStream(response);
    throw HttpException(
      'Failed to download avatar: ${response.statusCode} $body',
    );
  }

  final builder = BytesBuilder(copy: false);
  await for (final chunk in response) {
    builder.add(chunk);
  }

  return _DownloadResult(
    bytes: builder.takeBytes(),
    contentType: response.headers.contentType?.mimeType ?? 'image/jpeg',
  );
}

Future<void> _uploadAvatar({
  required HttpClient client,
  required String supabaseUrl,
  required String serviceRoleKey,
  required String path,
  required List<int> bytes,
  required String contentType,
}) async {
  final uri = Uri.parse('$supabaseUrl/storage/v1/object/avatars/$path');
  final request = await client.postUrl(uri);
  _applySupabaseHeaders(request, serviceRoleKey);
  request.headers.set(HttpHeaders.contentTypeHeader, contentType);
  request.headers.set('x-upsert', 'false');
  request.add(bytes);

  final response = await request.close();
  final body = await utf8.decodeStream(response);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw HttpException(
      'Failed to upload avatar: ${response.statusCode} $body',
    );
  }
}

Future<void> _updateAvatarUrl({
  required HttpClient client,
  required String supabaseUrl,
  required String serviceRoleKey,
  required String tenantId,
  required String userId,
  required String avatarUrl,
}) async {
  final uri = Uri.parse(
    '$supabaseUrl/rest/v1/tenant_user_profiles?tenant_id=eq.$tenantId&user_id=eq.$userId',
  );
  final request = await client.patchUrl(uri);
  _applySupabaseHeaders(request, serviceRoleKey);
  request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
  request.headers.set('Prefer', 'return=minimal');
  request.write(jsonEncode({'avatar_url': avatarUrl}));

  final response = await request.close();
  final body = await utf8.decodeStream(response);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw HttpException(
      'Failed to update avatar URL: ${response.statusCode} $body',
    );
  }
}

Future<void> _deleteAvatar({
  required HttpClient client,
  required String supabaseUrl,
  required String serviceRoleKey,
  required String path,
}) async {
  final uri = Uri.parse('$supabaseUrl/storage/v1/object/avatars/$path');
  final request = await client.deleteUrl(uri);
  _applySupabaseHeaders(request, serviceRoleKey);

  final response = await request.close();
  final body = await utf8.decodeStream(response);
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw HttpException(
      'Failed to delete avatar: ${response.statusCode} $body',
    );
  }
}

String? _extractStoragePath(String publicUrl) {
  final markerIndex = publicUrl.indexOf(_avatarMarker);
  if (markerIndex < 0) {
    return null;
  }

  final value = publicUrl.substring(markerIndex + _avatarMarker.length);
  final queryIndex = value.indexOf('?');
  if (queryIndex < 0) {
    return value;
  }
  return value.substring(0, queryIndex);
}

void _applySupabaseHeaders(HttpClientRequest request, String serviceRoleKey) {
  request.headers.set('apikey', serviceRoleKey);
  request.headers.set(
    HttpHeaders.authorizationHeader,
    'Bearer $serviceRoleKey',
  );
}

class _DownloadResult {
  const _DownloadResult({required this.bytes, required this.contentType});

  final List<int> bytes;
  final String contentType;
}
