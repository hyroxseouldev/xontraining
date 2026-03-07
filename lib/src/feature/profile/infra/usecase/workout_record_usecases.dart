import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/profile/data/repository/workout_record_repository.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';

part 'workout_record_usecases.g.dart';

class GetWorkoutRecordsUseCase {
  GetWorkoutRecordsUseCase({required this.repository});

  final WorkoutRecordRepository repository;

  Future<List<WorkoutRecordEntity>> call({required String tenantId}) {
    return repository.getMyRecords(tenantId: tenantId);
  }
}

class GetWorkoutExercisesUseCase {
  GetWorkoutExercisesUseCase({required this.repository});

  final WorkoutRecordRepository repository;

  Future<List<WorkoutExerciseEntity>> call({required String tenantId}) {
    return repository.getExercises(tenantId: tenantId);
  }
}

class GetWorkoutExercisePresetsUseCase {
  GetWorkoutExercisePresetsUseCase({required this.repository});

  final WorkoutRecordRepository repository;

  Future<List<WorkoutExercisePresetEntity>> call({required String tenantId}) {
    return repository.getExercisePresets(tenantId: tenantId);
  }
}

class CreateWorkoutRecordUseCase {
  CreateWorkoutRecordUseCase({required this.repository});

  final WorkoutRecordRepository repository;

  Future<void> call({
    required String tenantId,
    required String exerciseName,
    required WorkoutRecordType recordType,
    required int? distance,
    required int? recordSeconds,
    required double? recordWeightKg,
    required int? recordReps,
    required DateTime recordedAt,
    required String memo,
    required String? presetKey,
  }) {
    return repository.createMyRecord(
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
    );
  }
}

class UpdateWorkoutRecordUseCase {
  UpdateWorkoutRecordUseCase({required this.repository});

  final WorkoutRecordRepository repository;

  Future<void> call({
    required String id,
    required String tenantId,
    required String exerciseName,
    required WorkoutRecordType recordType,
    required int? distance,
    required int? recordSeconds,
    required double? recordWeightKg,
    required int? recordReps,
    required DateTime recordedAt,
    required String memo,
    required String? presetKey,
  }) {
    return repository.updateMyRecord(
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
    );
  }
}

class DeleteWorkoutRecordUseCase {
  DeleteWorkoutRecordUseCase({required this.repository});

  final WorkoutRecordRepository repository;

  Future<void> call({required String id, required String tenantId}) {
    return repository.deleteMyRecord(id: id, tenantId: tenantId);
  }
}

@riverpod
GetWorkoutRecordsUseCase getWorkoutRecordsUseCase(Ref ref) {
  return GetWorkoutRecordsUseCase(
    repository: ref.read(workoutRecordRepositoryProvider),
  );
}

@riverpod
GetWorkoutExercisesUseCase getWorkoutExercisesUseCase(Ref ref) {
  return GetWorkoutExercisesUseCase(
    repository: ref.read(workoutRecordRepositoryProvider),
  );
}

@riverpod
GetWorkoutExercisePresetsUseCase getWorkoutExercisePresetsUseCase(Ref ref) {
  return GetWorkoutExercisePresetsUseCase(
    repository: ref.read(workoutRecordRepositoryProvider),
  );
}

@riverpod
CreateWorkoutRecordUseCase createWorkoutRecordUseCase(Ref ref) {
  return CreateWorkoutRecordUseCase(
    repository: ref.read(workoutRecordRepositoryProvider),
  );
}

@riverpod
UpdateWorkoutRecordUseCase updateWorkoutRecordUseCase(Ref ref) {
  return UpdateWorkoutRecordUseCase(
    repository: ref.read(workoutRecordRepositoryProvider),
  );
}

@riverpod
DeleteWorkoutRecordUseCase deleteWorkoutRecordUseCase(Ref ref) {
  return DeleteWorkoutRecordUseCase(
    repository: ref.read(workoutRecordRepositoryProvider),
  );
}
