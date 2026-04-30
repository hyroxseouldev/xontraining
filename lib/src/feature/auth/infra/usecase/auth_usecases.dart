import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/auth/data/repository/auth_repository.dart';
import 'package:xontraining/src/feature/profile/infra/entity/profile_entity.dart';

part 'auth_usecases.g.dart';

class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call() {
    return repository.signInWithGoogle();
  }
}

class SignInWithAppleUseCase {
  SignInWithAppleUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call() {
    return repository.signInWithApple();
  }
}

class SignOutUseCase {
  SignOutUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call() {
    return repository.signOut();
  }
}

class CheckOnboardingStatusUseCase {
  CheckOnboardingStatusUseCase({required this.repository});

  final AuthRepository repository;

  Future<bool> call({required String tenantId}) {
    return repository.isOnboardingCompleted(tenantId: tenantId);
  }
}

class EnsureMyTenantProfileUseCase {
  EnsureMyTenantProfileUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call({required String tenantId}) {
    return repository.ensureMyTenantProfile(tenantId: tenantId);
  }
}

class CompleteOnboardingUseCase {
  CompleteOnboardingUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call({
    required String tenantId,
    required CompleteOnboardingParams params,
  }) {
    return repository.completeOnboarding(tenantId: tenantId, params: params);
  }
}

class GetMyProfileUseCase {
  GetMyProfileUseCase({required this.repository});

  final AuthRepository repository;

  Future<ProfileEntity> call({required String tenantId}) {
    return repository.getMyProfile(tenantId: tenantId);
  }
}

class UpdateMyProfileUseCase {
  UpdateMyProfileUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call({
    required String tenantId,
    required UpdateProfileParams params,
  }) {
    return repository.updateMyProfile(tenantId: tenantId, params: params);
  }
}

class GetMyTenantRoleUseCase {
  GetMyTenantRoleUseCase({required this.repository});

  final AuthRepository repository;

  Future<String?> call({required String tenantId}) {
    return repository.getMyTenantRole(tenantId: tenantId);
  }
}

class DeleteMyAccountUseCase {
  DeleteMyAccountUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call({required String tenantId}) {
    return repository.deleteMyAccount(tenantId: tenantId);
  }
}

@riverpod
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) {
  return SignInWithGoogleUseCase(repository: ref.read(authRepositoryProvider));
}

@riverpod
SignInWithAppleUseCase signInWithAppleUseCase(Ref ref) {
  return SignInWithAppleUseCase(repository: ref.read(authRepositoryProvider));
}

@riverpod
SignOutUseCase signOutUseCase(Ref ref) {
  return SignOutUseCase(repository: ref.read(authRepositoryProvider));
}

@riverpod
CheckOnboardingStatusUseCase checkOnboardingStatusUseCase(Ref ref) {
  return CheckOnboardingStatusUseCase(
    repository: ref.read(authRepositoryProvider),
  );
}

@riverpod
EnsureMyTenantProfileUseCase ensureMyTenantProfileUseCase(Ref ref) {
  return EnsureMyTenantProfileUseCase(
    repository: ref.read(authRepositoryProvider),
  );
}

@riverpod
CompleteOnboardingUseCase completeOnboardingUseCase(Ref ref) {
  return CompleteOnboardingUseCase(
    repository: ref.read(authRepositoryProvider),
  );
}

@riverpod
GetMyProfileUseCase getMyProfileUseCase(Ref ref) {
  return GetMyProfileUseCase(repository: ref.read(authRepositoryProvider));
}

@riverpod
UpdateMyProfileUseCase updateMyProfileUseCase(Ref ref) {
  return UpdateMyProfileUseCase(repository: ref.read(authRepositoryProvider));
}

@riverpod
GetMyTenantRoleUseCase getMyTenantRoleUseCase(Ref ref) {
  return GetMyTenantRoleUseCase(repository: ref.read(authRepositoryProvider));
}

@riverpod
DeleteMyAccountUseCase deleteMyAccountUseCase(Ref ref) {
  return DeleteMyAccountUseCase(repository: ref.read(authRepositoryProvider));
}
