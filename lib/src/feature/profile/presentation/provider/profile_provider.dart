import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/storage/storage_service.dart';
import 'package:xontraining/src/feature/auth/infra/usecase/auth_usecases.dart';

part 'profile_provider.g.dart';

@riverpod
Future<String> profileFullName(Ref ref) async {
  return (await ref.read(getMyFullNameUseCaseProvider).call()) ?? '';
}

@riverpod
Future<String?> profileAvatarUrl(Ref ref) async {
  return ref.read(getMyAvatarUrlUseCaseProvider).call();
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<bool> updateFullName({required String fullName}) async {
    state = const AsyncLoading();

    final nextState = await AsyncValue.guard(
      () => ref.read(updateMyFullNameUseCaseProvider).call(fullName: fullName),
    );

    if (!ref.mounted) {
      return false;
    }

    state = nextState;
    if (state.hasError) {
      return false;
    }

    ref.invalidate(profileFullNameProvider);
    return true;
  }

  Future<bool> saveProfile({
    required String fullName,
    Uint8List? avatarBytes,
    String? avatarFileName,
  }) async {
    state = const AsyncLoading();

    try {
      final trimmedName = fullName.trim();
      if (trimmedName.isNotEmpty) {
        await ref
            .read(updateMyFullNameUseCaseProvider)
            .call(fullName: trimmedName);
      }

      if (avatarBytes != null && avatarFileName != null) {
        final previousAvatarUrl = await ref
            .read(getMyAvatarUrlUseCaseProvider)
            .call();

        final uploadedAvatarUrl = await ref
            .read(storageServiceProvider)
            .uploadUserAvatar(bytes: avatarBytes, fileName: avatarFileName);

        await ref
            .read(updateMyAvatarUrlUseCaseProvider)
            .call(avatarUrl: uploadedAvatarUrl);

        if (previousAvatarUrl != null &&
            previousAvatarUrl.isNotEmpty &&
            previousAvatarUrl != uploadedAvatarUrl) {
          try {
            await ref
                .read(storageServiceProvider)
                .removeAvatarByPublicUrl(publicUrl: previousAvatarUrl);
          } catch (_) {}
        }
      }

      if (!ref.mounted) {
        return false;
      }

      state = const AsyncData(null);
      ref.invalidate(profileFullNameProvider);
      ref.invalidate(profileAvatarUrlProvider);
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
