import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/auth/infra/usecase/auth_usecases.dart';

part 'profile_provider.g.dart';

@riverpod
Future<String> profileFullName(Ref ref) async {
  return (await ref.read(getMyFullNameUseCaseProvider).call()) ?? '';
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
}
