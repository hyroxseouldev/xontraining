import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/storage/storage_service.dart';
import 'package:xontraining/src/feature/auth/data/repository/auth_repository.dart';
import 'package:xontraining/src/feature/auth/infra/usecase/auth_usecases.dart';
import 'package:xontraining/src/feature/profile/infra/entity/profile_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/profile_provider.dart';

void main() {
  group('ProfileController', () {
    test('saveProfile updates full name and returns true', () async {
      final authRepository = _FakeAuthRepository(
        profile: const ProfileEntity(
          fullName: 'Before',
          gender: ProfileGender.male,
        ),
      );
      final storageService = _FakeStorageService();

      final container = ProviderContainer(
        overrides: [
          getMyProfileUseCaseProvider.overrideWithValue(
            GetMyProfileUseCase(repository: authRepository),
          ),
          updateMyProfileUseCaseProvider.overrideWithValue(
            UpdateMyProfileUseCase(repository: authRepository),
          ),
          storageServiceProvider.overrideWithValue(storageService),
        ],
      );
      addTearDown(container.dispose);

      await container.read(profileProvider.future);

      final success = await container
          .read(profileControllerProvider.notifier)
          .saveProfile(fullName: 'After', gender: ProfileGender.female);

      final nextProfile = await container.read(profileProvider.future);

      expect(success, isTrue);
      expect(nextProfile.fullName, 'After');
      expect(nextProfile.gender, ProfileGender.female);
      expect(authRepository.updateProfileCalls, 1);
      expect(authRepository.lastUpdatedProfileParams?.fullName, 'After');
      expect(
        authRepository.lastUpdatedProfileParams?.gender,
        ProfileGender.female,
      );
    });

    test('saveProfile uploads avatar and removes previous avatar', () async {
      final authRepository = _FakeAuthRepository(
        profile: const ProfileEntity(
          fullName: 'Before',
          avatarUrl: 'https://cdn.test/old-avatar.jpg',
          gender: ProfileGender.male,
        ),
      );
      final storageService = _FakeStorageService(
        uploadedUrl: 'https://cdn.test/new-avatar.jpg',
      );

      final container = ProviderContainer(
        overrides: [
          getMyProfileUseCaseProvider.overrideWithValue(
            GetMyProfileUseCase(repository: authRepository),
          ),
          updateMyProfileUseCaseProvider.overrideWithValue(
            UpdateMyProfileUseCase(repository: authRepository),
          ),
          storageServiceProvider.overrideWithValue(storageService),
        ],
      );
      addTearDown(container.dispose);

      final success = await container
          .read(profileControllerProvider.notifier)
          .saveProfile(
            fullName: 'After',
            gender: ProfileGender.other,
            avatarBytes: Uint8List.fromList(const [1, 2, 3]),
            avatarFileName: 'avatar.png',
          );

      expect(success, isTrue);
      expect(storageService.uploadAvatarCalls, 1);
      expect(storageService.lastUploadedFileName, 'avatar.png');
      expect(
        authRepository.lastUpdatedProfileParams?.avatarUrl,
        'https://cdn.test/new-avatar.jpg',
      );
      expect(
        authRepository.lastUpdatedProfileParams?.gender,
        ProfileGender.other,
      );
      expect(storageService.removedAvatarUrls, [
        'https://cdn.test/old-avatar.jpg',
      ]);
    });

    test('saveProfile returns false when upload fails', () async {
      final authRepository = _FakeAuthRepository(
        profile: const ProfileEntity(
          fullName: 'Before',
          avatarUrl: 'https://cdn.test/old-avatar.jpg',
          gender: ProfileGender.male,
        ),
      );
      final storageService = _FakeStorageService(throwOnUpload: true);

      final container = ProviderContainer(
        overrides: [
          getMyProfileUseCaseProvider.overrideWithValue(
            GetMyProfileUseCase(repository: authRepository),
          ),
          updateMyProfileUseCaseProvider.overrideWithValue(
            UpdateMyProfileUseCase(repository: authRepository),
          ),
          storageServiceProvider.overrideWithValue(storageService),
        ],
      );
      addTearDown(container.dispose);

      final success = await container
          .read(profileControllerProvider.notifier)
          .saveProfile(
            fullName: 'After',
            gender: ProfileGender.preferNotToSay,
            avatarBytes: Uint8List.fromList(const [1, 2, 3]),
            avatarFileName: 'avatar.png',
          );

      expect(success, isFalse);
      expect(container.read(profileControllerProvider).hasError, isTrue);
      expect(authRepository.updateProfileCalls, 0);
      expect(storageService.removedAvatarUrls, isEmpty);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.profile});

  ProfileEntity profile;

  int updateProfileCalls = 0;
  UpdateProfileParams? lastUpdatedProfileParams;

  @override
  Future<ProfileEntity> getMyProfile() async => profile;

  @override
  Future<void> updateMyProfile({required UpdateProfileParams params}) async {
    updateProfileCalls += 1;
    lastUpdatedProfileParams = params;
    profile = ProfileEntity(
      fullName: params.fullName,
      avatarUrl: params.avatarUrl,
      gender: params.gender,
      onboardingCompleted: profile.onboardingCompleted,
      fallbackFullName: profile.fallbackFullName,
      fallbackAvatarUrl: profile.fallbackAvatarUrl,
    );
  }

  @override
  Future<void> completeOnboarding({required CompleteOnboardingParams params}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMyAccount({required String tenantId}) {
    throw UnimplementedError();
  }

  @override
  Future<String?> getMyTenantRole({required String tenantId}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isOnboardingCompleted() {
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }
}

class _FakeStorageService implements StorageService {
  _FakeStorageService({
    this.uploadedUrl = 'https://cdn.test/uploaded-avatar.jpg',
    this.throwOnUpload = false,
  });

  final String uploadedUrl;
  final bool throwOnUpload;

  int uploadAvatarCalls = 0;
  String? lastUploadedFileName;
  final List<String> removedAvatarUrls = <String>[];

  @override
  Future<String> uploadUserAvatar({
    required Uint8List bytes,
    required String fileName,
  }) async {
    uploadAvatarCalls += 1;
    lastUploadedFileName = fileName;
    if (throwOnUpload) {
      throw StateError('upload failed');
    }
    return uploadedUrl;
  }

  @override
  Future<void> removeAvatarByPublicUrl({required String publicUrl}) async {
    removedAvatarUrls.add(publicUrl);
  }

  @override
  Future<void> removeCommunityMediaByPublicUrl({required String publicUrl}) {
    throw UnimplementedError();
  }

  @override
  Future<String> uploadCommunityImage({
    required Uint8List bytes,
    required String fileName,
  }) {
    throw UnimplementedError();
  }
}
