import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/auth/data/datasource/auth_data_source.dart';
import 'package:xontraining/src/feature/profile/infra/entity/profile_entity.dart';

part 'auth_repository.g.dart';

abstract interface class AuthRepository {
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
  Future<void> signOut();
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding({required CompleteOnboardingParams params});
  Future<ProfileEntity> getMyProfile();
  Future<void> updateMyProfile({required UpdateProfileParams params});
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
  Future<void> signInWithApple() async {
    try {
      debugPrint('[AuthRepository] signInWithApple started');
      await dataSource.signInWithApple();
      debugPrint('[AuthRepository] signInWithApple success');
    } on SignInWithAppleAuthorizationException catch (error, stackTrace) {
      debugPrint('[AuthRepository] signInWithApple apple failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');

      if (error.code == AuthorizationErrorCode.canceled) {
        throw AppException.authCanceled(cause: error);
      }

      throw AppException.auth(message: error.message, cause: error);
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] signInWithApple auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[AuthRepository] signInWithApple unexpected failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Apple sign-in failed.',
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
  Future<void> completeOnboarding({
    required CompleteOnboardingParams params,
  }) async {
    try {
      await dataSource.completeOnboarding(gender: params.gender.databaseValue);
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
  Future<ProfileEntity> getMyProfile() async {
    try {
      final profile = await dataSource.getMyProfile();
      return ProfileEntity(
        fullName: profile['full_name'] as String?,
        avatarUrl: profile['avatar_url'] as String?,
        gender: ProfileGender.fromDatabaseValue(profile['gender'] as String?),
        onboardingCompleted: profile['onboarding_completed'] as bool? ?? false,
        fallbackFullName: profile['fallback_full_name'] as String?,
        fallbackAvatarUrl: profile['fallback_avatar_url'] as String?,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] getMyProfile auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[AuthRepository] getMyProfile unexpected failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load profile.',
        cause: error,
      );
    }
  }

  @override
  Future<void> updateMyProfile({required UpdateProfileParams params}) async {
    try {
      await dataSource.updateMyProfile(
        fullName: params.fullName,
        gender: params.gender.databaseValue,
        avatarUrl: params.avatarUrl,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint('[AuthRepository] updateMyProfile auth failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[AuthRepository] updateMyProfile unexpected failure: $error');
      debugPrint('[AuthRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to update profile.',
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
        message: 'Failed to deactivate account.',
        cause: error,
      );
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(dataSource: ref.read(authDataSourceProvider));
}
