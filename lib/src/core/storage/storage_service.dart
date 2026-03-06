import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'storage_service.g.dart';

const String _avatarsBucket = 'avatars';
const String _communityMediaBucket = 'content-media';

abstract interface class StorageService {
  Future<String> uploadUserAvatar({
    required Uint8List bytes,
    required String fileName,
  });

  Future<void> removeAvatarByPublicUrl({required String publicUrl});

  Future<void> removeCommunityMediaByPublicUrl({required String publicUrl});

  Future<String> uploadCommunityImage({
    required Uint8List bytes,
    required String fileName,
  });
}

class SupabaseStorageService implements StorageService {
  SupabaseStorageService({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<String> uploadUserAvatar({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final ext = _resolveFileExtension(fileName);
    final mimeType = _resolveMimeType(ext);
    final nowMs = DateTime.now().microsecondsSinceEpoch;
    final path = 'users/$userId/avatar_$nowMs.$ext';

    final uploadedPath = await supabase.storage
        .from(_avatarsBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: mimeType,
            cacheControl: '3600',
            upsert: false,
          ),
        );

    return supabase.storage.from(_avatarsBucket).getPublicUrl(uploadedPath);
  }

  @override
  Future<void> removeAvatarByPublicUrl({required String publicUrl}) async {
    final path = _extractAvatarPathFromPublicUrl(publicUrl);
    if (path == null || path.isEmpty) {
      return;
    }

    await supabase.storage.from(_avatarsBucket).remove([path]);
  }

  @override
  Future<void> removeCommunityMediaByPublicUrl({
    required String publicUrl,
  }) async {
    final path = _extractPublicPathFromUrl(
      publicUrl: publicUrl,
      bucketName: _communityMediaBucket,
    );
    if (path == null || path.isEmpty) {
      return;
    }

    await supabase.storage.from(_communityMediaBucket).remove([path]);
  }

  @override
  Future<String> uploadCommunityImage({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final ext = _resolveFileExtension(fileName);
    final mimeType = _resolveMimeType(ext);
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final path = 'users/$userId/community/img_$nowMs.$ext';

    final uploadedPath = await supabase.storage
        .from(_communityMediaBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: mimeType,
            cacheControl: '3600',
            upsert: false,
          ),
        );

    return supabase.storage
        .from(_communityMediaBucket)
        .getPublicUrl(uploadedPath);
  }

  String _resolveFileExtension(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex < 0 || dotIndex == fileName.length - 1) {
      return 'jpg';
    }

    final ext = fileName.substring(dotIndex + 1).trim().toLowerCase();
    if (ext == 'jpeg' || ext == 'jpg' || ext == 'png' || ext == 'webp') {
      return ext == 'jpeg' ? 'jpg' : ext;
    }

    return 'jpg';
  }

  String _resolveMimeType(String extension) {
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'jpg':
      default:
        return 'image/jpeg';
    }
  }

  String? _extractAvatarPathFromPublicUrl(String publicUrl) {
    return _extractPublicPathFromUrl(
      publicUrl: publicUrl,
      bucketName: _avatarsBucket,
    );
  }

  String? _extractPublicPathFromUrl({
    required String publicUrl,
    required String bucketName,
  }) {
    final marker = '/storage/v1/object/public/$bucketName/';
    final markerIndex = publicUrl.indexOf(marker);
    if (markerIndex < 0) {
      return null;
    }

    final path = publicUrl.substring(markerIndex + marker.length);
    final queryIndex = path.indexOf('?');
    if (queryIndex < 0) {
      return path;
    }

    return path.substring(0, queryIndex);
  }
}

@riverpod
StorageService storageService(Ref ref) {
  return SupabaseStorageService(supabase: ref.read(supabaseClientProvider));
}
