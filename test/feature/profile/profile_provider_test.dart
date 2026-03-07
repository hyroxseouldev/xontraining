import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/storage/storage_service.dart';
import 'package:xontraining/src/feature/auth/data/repository/auth_repository.dart';
import 'package:xontraining/src/feature/auth/infra/usecase/auth_usecases.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/profile_provider.dart';

void main() {
  group('ProfileController', () {
    test('saveProfile updates full name and returns true', () async {
      final authRepository = _FakeAuthRepository(fullName: 'Before');
      final storageService = _FakeStorageService();

      final container = ProviderContainer(
        overrides: [
          getMyFullNameUseCaseProvider.overrideWithValue(
            GetMyFullNameUseCase(repository: authRepository),
          ),
          getMyAvatarUrlUseCaseProvider.overrideWithValue(
            GetMyAvatarUrlUseCase(repository: authRepository),
          ),
          updateMyFullNameUseCaseProvider.overrideWithValue(
            UpdateMyFullNameUseCase(repository: authRepository),
          ),
          updateMyAvatarUrlUseCaseProvider.overrideWithValue(
            UpdateMyAvatarUrlUseCase(repository: authRepository),
          ),
          storageServiceProvider.overrideWithValue(storageService),
        ],
      );
      addTearDown(container.dispose);

      await container.read(profileFullNameProvider.future);

      final success = await container
          .read(profileControllerProvider.notifier)
          .saveProfile(fullName: 'After');

      final nextName = await container.read(profileFullNameProvider.future);

      expect(success, isTrue);
      expect(nextName, 'After');
      expect(authRepository.updateFullNameCalls, 1);
      expect(authRepository.lastUpdatedFullName, 'After');
    });

    test('saveProfile uploads avatar and removes previous avatar', () async {
      final authRepository = _FakeAuthRepository(
        fullName: 'Before',
        avatarUrl: 'https://cdn.test/old-avatar.jpg',
      );
      final storageService = _FakeStorageService(
        uploadedUrl: 'https://cdn.test/new-avatar.jpg',
      );

      final container = ProviderContainer(
        overrides: [
          getMyFullNameUseCaseProvider.overrideWithValue(
            GetMyFullNameUseCase(repository: authRepository),
          ),
          getMyAvatarUrlUseCaseProvider.overrideWithValue(
            GetMyAvatarUrlUseCase(repository: authRepository),
          ),
          updateMyFullNameUseCaseProvider.overrideWithValue(
            UpdateMyFullNameUseCase(repository: authRepository),
          ),
          updateMyAvatarUrlUseCaseProvider.overrideWithValue(
            UpdateMyAvatarUrlUseCase(repository: authRepository),
          ),
          storageServiceProvider.overrideWithValue(storageService),
        ],
      );
      addTearDown(container.dispose);

      final success = await container
          .read(profileControllerProvider.notifier)
          .saveProfile(
            fullName: 'After',
            avatarBytes: Uint8List.fromList(const [1, 2, 3]),
            avatarFileName: 'avatar.png',
          );

      expect(success, isTrue);
      expect(storageService.uploadAvatarCalls, 1);
      expect(storageService.lastUploadedFileName, 'avatar.png');
      expect(
        authRepository.lastUpdatedAvatarUrl,
        'https://cdn.test/new-avatar.jpg',
      );
      expect(storageService.removedAvatarUrls, [
        'https://cdn.test/old-avatar.jpg',
      ]);
    });

    test('saveProfile returns false when upload fails', () async {
      final authRepository = _FakeAuthRepository(
        fullName: 'Before',
        avatarUrl: 'https://cdn.test/old-avatar.jpg',
      );
      final storageService = _FakeStorageService(throwOnUpload: true);

      final container = ProviderContainer(
        overrides: [
          getMyFullNameUseCaseProvider.overrideWithValue(
            GetMyFullNameUseCase(repository: authRepository),
          ),
          getMyAvatarUrlUseCaseProvider.overrideWithValue(
            GetMyAvatarUrlUseCase(repository: authRepository),
          ),
          updateMyFullNameUseCaseProvider.overrideWithValue(
            UpdateMyFullNameUseCase(repository: authRepository),
          ),
          updateMyAvatarUrlUseCaseProvider.overrideWithValue(
            UpdateMyAvatarUrlUseCase(repository: authRepository),
          ),
          storageServiceProvider.overrideWithValue(storageService),
        ],
      );
      addTearDown(container.dispose);

      final success = await container
          .read(profileControllerProvider.notifier)
          .saveProfile(
            fullName: 'After',
            avatarBytes: Uint8List.fromList(const [1, 2, 3]),
            avatarFileName: 'avatar.png',
          );

      expect(success, isFalse);
      expect(container.read(profileControllerProvider).hasError, isTrue);
      expect(authRepository.updateAvatarUrlCalls, 0);
      expect(storageService.removedAvatarUrls, isEmpty);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.fullName, this.avatarUrl});

  String? fullName;
  String? avatarUrl;

  int updateFullNameCalls = 0;
  int updateAvatarUrlCalls = 0;
  String? lastUpdatedFullName;
  String? lastUpdatedAvatarUrl;

  @override
  Future<String?> getMyFullName() async => fullName;

  @override
  Future<String?> getMyAvatarUrl() async => avatarUrl;

  @override
  Future<void> updateMyFullName({required String fullName}) async {
    updateFullNameCalls += 1;
    lastUpdatedFullName = fullName;
    this.fullName = fullName;
  }

  @override
  Future<void> updateMyAvatarUrl({required String avatarUrl}) async {
    updateAvatarUrlCalls += 1;
    lastUpdatedAvatarUrl = avatarUrl;
    this.avatarUrl = avatarUrl;
  }

  @override
  Future<void> completeOnboarding({required String fullName}) {
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
