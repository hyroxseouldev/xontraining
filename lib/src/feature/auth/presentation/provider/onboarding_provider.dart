import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/auth/infra/usecase/auth_usecases.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';

part 'onboarding_provider.g.dart';

@riverpod
Future<bool> onboardingCompleted(Ref ref) async {
  final user = await ref.watch(authSessionProvider.future);
  if (user == null) {
    return false;
  }

  return ref.read(checkOnboardingStatusUseCaseProvider).call();
}

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<bool> completeOnboarding({required String fullName}) async {
    state = const AsyncLoading();
    final nextState = await AsyncValue.guard(
      () =>
          ref.read(completeOnboardingUseCaseProvider).call(fullName: fullName),
    );

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
