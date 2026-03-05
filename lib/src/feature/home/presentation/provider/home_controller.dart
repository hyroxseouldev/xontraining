import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/infra/usecase/home_usecases.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  Future<HomeState> build() async {
    final selectedDate = _toDateOnly(DateTime.now());
    final activeProgram = await ref
        .read(getCurrentActiveProgramUseCaseProvider)
        .call();

    if (activeProgram == null) {
      return HomeState(selectedDate: selectedDate);
    }

    final sections = await ref
        .read(getBlueprintSectionsUseCaseProvider)
        .call(programId: activeProgram.id, date: selectedDate);

    return HomeState(
      selectedDate: selectedDate,
      activeProgram: activeProgram,
      sections: sections,
    );
  }

  Future<void> selectDate(DateTime date) async {
    final previousState = state.asData?.value;
    final activeProgram = previousState?.activeProgram;
    if (previousState == null || activeProgram == null) {
      return;
    }

    final selectedDate = _toDateOnly(date);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final sections = await ref
          .read(getBlueprintSectionsUseCaseProvider)
          .call(programId: activeProgram.id, date: selectedDate);

      return previousState.copyWith(
        selectedDate: selectedDate,
        sections: sections,
      );
    });
  }

  DateTime _toDateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
