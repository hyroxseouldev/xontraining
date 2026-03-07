import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';
import 'package:xontraining/src/feature/profile/infra/usecase/workout_record_usecases.dart';

part 'workout_record_provider.g.dart';

@riverpod
Future<List<WorkoutRecordEntity>> workoutRecords(Ref ref) async {
  final tenantId = ref.read(tenantIdProvider);
  return ref.read(getWorkoutRecordsUseCaseProvider).call(tenantId: tenantId);
}

@riverpod
Future<List<WorkoutExerciseEntity>> workoutExercises(Ref ref) async {
  final tenantId = ref.read(tenantIdProvider);
  return ref.read(getWorkoutExercisesUseCaseProvider).call(tenantId: tenantId);
}

@riverpod
Future<List<WorkoutExercisePresetEntity>> workoutExercisePresets(
  Ref ref,
) async {
  final tenantId = ref.read(tenantIdProvider);
  return ref
      .read(getWorkoutExercisePresetsUseCaseProvider)
      .call(tenantId: tenantId);
}

@riverpod
class WorkoutRecordController extends _$WorkoutRecordController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> createRecord({
    required String exerciseName,
    required WorkoutRecordType recordType,
    required int? distance,
    required int? recordSeconds,
    required double? recordWeightKg,
    required int? recordReps,
    required DateTime recordedAt,
    required String memo,
    required String? presetKey,
  }) async {
    state = const AsyncLoading();

    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(createWorkoutRecordUseCaseProvider)
          .call(
            tenantId: tenantId,
            exerciseName: exerciseName,
            recordType: recordType,
            distance: distance,
            recordSeconds: recordSeconds,
            recordWeightKg: recordWeightKg,
            recordReps: recordReps,
            recordedAt: recordedAt,
            memo: memo,
            presetKey: presetKey,
          ),
    );

    if (!ref.mounted) {
      return;
    }

    state = nextState;
    if (!state.hasError) {
      ref.invalidate(workoutRecordsProvider);
    }
  }

  Future<void> updateRecord({
    required String id,
    required String exerciseName,
    required WorkoutRecordType recordType,
    required int? distance,
    required int? recordSeconds,
    required double? recordWeightKg,
    required int? recordReps,
    required DateTime recordedAt,
    required String memo,
    required String? presetKey,
  }) async {
    state = const AsyncLoading();

    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(updateWorkoutRecordUseCaseProvider)
          .call(
            id: id,
            tenantId: tenantId,
            exerciseName: exerciseName,
            recordType: recordType,
            distance: distance,
            recordSeconds: recordSeconds,
            recordWeightKg: recordWeightKg,
            recordReps: recordReps,
            recordedAt: recordedAt,
            memo: memo,
            presetKey: presetKey,
          ),
    );

    if (!ref.mounted) {
      return;
    }

    state = nextState;
    if (!state.hasError) {
      ref.invalidate(workoutRecordsProvider);
    }
  }

  Future<void> deleteRecord({required String id}) async {
    state = const AsyncLoading();

    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(deleteWorkoutRecordUseCaseProvider)
          .call(id: id, tenantId: tenantId),
    );

    if (!ref.mounted) {
      return;
    }

    state = nextState;
    if (!state.hasError) {
      ref.invalidate(workoutRecordsProvider);
    }
  }
}
