import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/auth/data/repository/auth_repository.dart';

part 'auth_usecases.g.dart';

class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call() {
    return repository.signInWithGoogle();
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

  Future<bool> call() {
    return repository.isOnboardingCompleted();
  }
}

class CompleteOnboardingUseCase {
  CompleteOnboardingUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call({required String fullName}) {
    return repository.completeOnboarding(fullName: fullName);
  }
}

class GetMyFullNameUseCase {
  GetMyFullNameUseCase({required this.repository});

  final AuthRepository repository;

  Future<String?> call() {
    return repository.getMyFullName();
  }
}

class UpdateMyFullNameUseCase {
  UpdateMyFullNameUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call({required String fullName}) {
    return repository.updateMyFullName(fullName: fullName);
  }
}

@riverpod
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) {
  return SignInWithGoogleUseCase(repository: ref.read(authRepositoryProvider));
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
CompleteOnboardingUseCase completeOnboardingUseCase(Ref ref) {
  return CompleteOnboardingUseCase(
    repository: ref.read(authRepositoryProvider),
  );
}

@riverpod
GetMyFullNameUseCase getMyFullNameUseCase(Ref ref) {
  return GetMyFullNameUseCase(repository: ref.read(authRepositoryProvider));
}

@riverpod
UpdateMyFullNameUseCase updateMyFullNameUseCase(Ref ref) {
  return UpdateMyFullNameUseCase(repository: ref.read(authRepositoryProvider));
}
