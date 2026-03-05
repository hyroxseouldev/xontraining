import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/auth/data/datasource/auth_data_source.dart';

part 'auth_repository.g.dart';

abstract interface class AuthRepository {
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding({required String fullName});
  Future<String?> getMyFullName();
  Future<String?> getMyAvatarUrl();
  Future<void> updateMyFullName({required String fullName});
  Future<void> updateMyAvatarUrl({required String avatarUrl});
  Future<String?> getMyTenantRole({required String tenantId});
  Future<void> deleteMyAccount({required String tenantId});
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.dataSource});

  final AuthDataSource dataSource;

  @override
  Future<void> signInWithGoogle() async {
    try {
      debugPrint('[AuthRepository] signInWithGoogle started');
      await dataSource.signInWithGoogle();
      debugPrint('[AuthRepository] signInWithGoogle success');
    } on GoogleSignInException catch (error, stackTrace) {
      debugPrint('[AuthRepository] signInWithGoogle google failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      switch (error.code) {
        case GoogleSignInExceptionCode.canceled:
        case GoogleSignInExceptionCode.interrupted:
          throw AppException.auth(
            message: 'Google sign-in was canceled.',
            cause: error,
          );
        case GoogleSignInExceptionCode.clientConfigurationError:
        case GoogleSignInExceptionCode.providerConfigurationError:
        case GoogleSignInExceptionCode.uiUnavailable:
        case GoogleSignInExceptionCode.userMismatch:
          throw AppException.auth(
            message: error.description ?? 'Google sign-in configuration error.',
            cause: error,
          );
        case GoogleSignInExceptionCode.unknownError:
          throw AppException.auth(
            message: error.description ?? 'Google sign-in failed.',
            cause: error,
          );
      }
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] signInWithGoogle auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[AuthRepository] signInWithGoogle unexpected failure: $error',
      );
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Google sign-in failed.',
        cause: error,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      debugPrint('[AuthRepository] signOut started');
      await dataSource.signOut();
      debugPrint('[AuthRepository] signOut success');
    } catch (error, stackTrace) {
      debugPrint('[AuthRepository] signOut failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(message: 'Sign-out failed.', cause: error);
    }
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      return await dataSource.isOnboardingCompleted();
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] isOnboardingCompleted auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[AuthRepository] isOnboardingCompleted unexpected failure: $error',
      );
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to check onboarding status.',
        cause: error,
      );
    }
  }

  @override
  Future<void> completeOnboarding({required String fullName}) async {
    try {
      await dataSource.completeOnboarding(fullName: fullName);
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] completeOnboarding auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[AuthRepository] completeOnboarding unexpected failure: $error',
      );
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to complete onboarding.',
        cause: error,
      );
    }
  }

  @override
  Future<String?> getMyFullName() async {
    try {
      return await dataSource.getMyFullName();
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] getMyFullName auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[AuthRepository] getMyFullName unexpected failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load profile.',
        cause: error,
      );
    }
  }

  @override
  Future<String?> getMyAvatarUrl() async {
    try {
      return await dataSource.getMyAvatarUrl();
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] getMyAvatarUrl auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[AuthRepository] getMyAvatarUrl unexpected failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load profile image.',
        cause: error,
      );
    }
  }

  @override
  Future<void> updateMyFullName({required String fullName}) async {
    try {
      await dataSource.updateMyFullName(fullName: fullName);
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] updateMyFullName auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[AuthRepository] updateMyFullName unexpected failure: $error',
      );
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to update profile.',
        cause: error,
      );
    }
  }

  @override
  Future<void> updateMyAvatarUrl({required String avatarUrl}) async {
    try {
      await dataSource.updateMyAvatarUrl(avatarUrl: avatarUrl);
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] updateMyAvatarUrl auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[AuthRepository] updateMyAvatarUrl unexpected failure: $error',
      );
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to update profile image.',
        cause: error,
      );
    }
  }

  @override
  Future<String?> getMyTenantRole({required String tenantId}) async {
    try {
      return await dataSource.getMyTenantRole(tenantId: tenantId);
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] getMyTenantRole auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[AuthRepository] getMyTenantRole unexpected failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load membership role.',
        cause: error,
      );
    }
  }

  @override
  Future<void> deleteMyAccount({required String tenantId}) async {
    try {
      await dataSource.deleteMyAccount(tenantId: tenantId);
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] deleteMyAccount auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[AuthRepository] deleteMyAccount unexpected failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to delete account.',
        cause: error,
      );
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(dataSource: ref.read(authDataSourceProvider));
}
