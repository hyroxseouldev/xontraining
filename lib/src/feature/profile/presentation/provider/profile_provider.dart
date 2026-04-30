import 'dart:typed_data';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/core/storage/storage_service.dart';
import 'package:xontraining/src/feature/auth/infra/usecase/auth_usecases.dart';
import 'package:xontraining/src/feature/profile/infra/entity/profile_entity.dart';

part 'profile_provider.g.dart';

@riverpod
Future<ProfileEntity> profile(Ref ref) async {
  final tenantId = ref.read(tenantIdProvider);
  await ref.read(ensureMyTenantProfileUseCaseProvider).call(tenantId: tenantId);
  return ref.read(getMyProfileUseCaseProvider).call(tenantId: tenantId);
}

@riverpod
Future<String?> profileTenantRole(Ref ref) async {
  final tenantId = ref.read(tenantIdProvider);
  return ref.read(getMyTenantRoleUseCaseProvider).call(tenantId: tenantId);
}

@riverpod
Future<String> appVersionLabel(Ref ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return '${packageInfo.version}+${packageInfo.buildNumber}';
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<bool> saveProfile({
    required String fullName,
    required ProfileGender gender,
    Uint8List? avatarBytes,
    String? avatarFileName,
  }) async {
    state = const AsyncLoading();
    final tenantId = ref.read(tenantIdProvider);

    try {
      final trimmedName = fullName.trim();
      await ref
          .read(ensureMyTenantProfileUseCaseProvider)
          .call(tenantId: tenantId);
      final currentProfile = await ref
          .read(getMyProfileUseCaseProvider)
          .call(tenantId: tenantId);
      var nextAvatarUrl = currentProfile.normalizedAvatarUrl;

      if (avatarBytes != null && avatarFileName != null) {
        final uploadedAvatarUrl = await ref
            .read(storageServiceProvider)
            .uploadUserAvatar(
              tenantId: tenantId,
              bytes: avatarBytes,
              fileName: avatarFileName,
            );

        if (nextAvatarUrl.isNotEmpty && nextAvatarUrl != uploadedAvatarUrl) {
          try {
            await ref
                .read(storageServiceProvider)
                .removeAvatarByPublicUrl(publicUrl: nextAvatarUrl);
          } catch (_) {}
        }

        nextAvatarUrl = uploadedAvatarUrl;
      }

      await ref
          .read(updateMyProfileUseCaseProvider)
          .call(
            tenantId: tenantId,
            params: UpdateProfileParams(
              fullName: trimmedName,
              gender: gender,
              avatarUrl: nextAvatarUrl.isEmpty ? null : nextAvatarUrl,
            ),
          );

      if (!ref.mounted) {
        return false;
      }

      state = const AsyncData(null);
      ref.invalidate(profileProvider);
      return true;
    } catch (error, stackTrace) {
      if (!ref.mounted) {
        return false;
      }

      state = AsyncError(error, stackTrace);
      return false;
    }
  }
}
