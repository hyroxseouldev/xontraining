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

class CreateWorkoutRecordUseCase {
  CreateWorkoutRecordUseCase({required this.repository});

  final WorkoutRecordRepository repository;

  Future<void> call({
    required String tenantId,
    required String exerciseName,
    required WorkoutRecordMetricType metricType,
    required double? valueNumeric,
    required int? valueSeconds,
    required String unit,
    required DateTime recordedAt,
    required String memo,
  }) {
    return repository.createMyRecord(
      tenantId: tenantId,
      exerciseName: exerciseName,
      metricType: metricType,
      valueNumeric: valueNumeric,
      valueSeconds: valueSeconds,
      unit: unit,
      recordedAt: recordedAt,
      memo: memo,
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
    required WorkoutRecordMetricType metricType,
    required double? valueNumeric,
    required int? valueSeconds,
    required String unit,
    required DateTime recordedAt,
    required String memo,
  }) {
    return repository.updateMyRecord(
      id: id,
      tenantId: tenantId,
      exerciseName: exerciseName,
      metricType: metricType,
      valueNumeric: valueNumeric,
      valueSeconds: valueSeconds,
      unit: unit,
      recordedAt: recordedAt,
      memo: memo,
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
