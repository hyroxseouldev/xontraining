import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/auth/infra/usecase/auth_usecases.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';
import 'package:xontraining/src/feature/profile/infra/entity/profile_entity.dart';

part 'onboarding_provider.g.dart';

@riverpod
Future<bool> onboardingCompleted(Ref ref) async {
  final user = await ref.watch(authSessionProvider.future);
  if (user == null) {
    return false;
  }

  final tenantId = ref.read(tenantIdProvider);

  try {
    await ref
        .read(ensureMyTenantProfileUseCaseProvider)
        .call(tenantId: tenantId);
    final profile = await ref
        .read(getMyProfileUseCaseProvider)
        .call(tenantId: tenantId);
    return profile.onboardingCompleted;
  } on AppException catch (error) {
    final shouldForceSignOut = error.maybeWhen(
      auth: (message, _) => message == 'Account has been deactivated.',
      orElse: () => false,
    );

    if (shouldForceSignOut) {
      await ref.read(signOutUseCaseProvider).call();
      return false;
    }
    rethrow;
  }
}

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<bool> completeOnboarding({required ProfileGender gender}) async {
    state = const AsyncLoading();
    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(() async {
      await ref
          .read(ensureMyTenantProfileUseCaseProvider)
          .call(tenantId: tenantId);
      await ref
          .read(completeOnboardingUseCaseProvider)
          .call(
            tenantId: tenantId,
            params: CompleteOnboardingParams(gender: gender),
          );
    });

    if (!ref.mounted) {
      return false;
    }

    state = nextState;

    if (state.hasError) {
      return false;
    }

    ref.invalidate(onboardingCompletedProvider);
    return true;
  }
}
