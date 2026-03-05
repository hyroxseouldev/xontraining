import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/auth/infra/usecase/auth_usecases.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/onboarding_provider.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    final nextState = await AsyncValue.guard(
      () => ref.read(signInWithGoogleUseCaseProvider).call(),
    );

    if (!ref.mounted) {
      return;
    }

    state = nextState;

    if (!state.hasError) {
      ref.invalidate(onboardingCompletedProvider);
    }
  }

  Future<void> signOut() async {
    await ref.read(signOutUseCaseProvider).call();

    if (!ref.mounted) {
      return;
    }

    ref.invalidate(onboardingCompletedProvider);
  }

  Future<void> deleteMyAccount() async {
    state = const AsyncLoading();

    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref.read(deleteMyAccountUseCaseProvider).call(tenantId: tenantId),
    );

    if (!ref.mounted) {
      return;
    }

    state = nextState;

    if (state.hasError) {
      return;
    }

    await ref.read(signOutUseCaseProvider).call();

    ref.invalidate(onboardingCompletedProvider);
  }
}
