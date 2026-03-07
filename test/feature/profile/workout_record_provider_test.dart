import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/profile/data/repository/workout_record_repository.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';
import 'package:xontraining/src/feature/profile/infra/usecase/workout_record_usecases.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/workout_record_provider.dart';

void main() {
  group('WorkoutRecordController', () {
    test('createRecord calls use case and invalidates workout list', () async {
      final repository = _FakeWorkoutRecordRepository(
        recordsResponse: [
          _record(id: 'r1'),
          _record(id: 'r2'),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          getWorkoutRecordsUseCaseProvider.overrideWithValue(
            GetWorkoutRecordsUseCase(repository: repository),
          ),
          createWorkoutRecordUseCaseProvider.overrideWithValue(
            CreateWorkoutRecordUseCase(repository: repository),
          ),
          updateWorkoutRecordUseCaseProvider.overrideWithValue(
            UpdateWorkoutRecordUseCase(repository: repository),
          ),
          deleteWorkoutRecordUseCaseProvider.overrideWithValue(
            DeleteWorkoutRecordUseCase(repository: repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(workoutRecordsProvider.future);

      await container
          .read(workoutRecordControllerProvider.notifier)
          .createRecord(
            exerciseName: 'rowing',
            recordType: WorkoutRecordType.time,
            distance: 2000,
            recordSeconds: 430,
            recordWeightKg: null,
            recordReps: null,
            recordedAt: DateTime(2026, 3, 1),
            memo: 'test memo',
            presetKey: '2000m',
          );

      await container.read(workoutRecordsProvider.future);

      expect(repository.getMyRecordsCalls, 2);
      expect(repository.createCalls, 1);
      expect(repository.lastCreatedExerciseName, 'rowing');
      expect(repository.lastCreatedRecordType, WorkoutRecordType.time);
      expect(repository.lastCreatedDistance, 2000);
      expect(repository.lastCreatedRecordSeconds, 430);
    });

    test('updateRecord forwards values to repository', () async {
      final repository = _FakeWorkoutRecordRepository(
        recordsResponse: const [],
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          getWorkoutRecordsUseCaseProvider.overrideWithValue(
            GetWorkoutRecordsUseCase(repository: repository),
          ),
          createWorkoutRecordUseCaseProvider.overrideWithValue(
            CreateWorkoutRecordUseCase(repository: repository),
          ),
          updateWorkoutRecordUseCaseProvider.overrideWithValue(
            UpdateWorkoutRecordUseCase(repository: repository),
          ),
          deleteWorkoutRecordUseCaseProvider.overrideWithValue(
            DeleteWorkoutRecordUseCase(repository: repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(workoutRecordControllerProvider.notifier)
          .updateRecord(
            id: 'record-id',
            exerciseName: 'squat',
            recordType: WorkoutRecordType.weight,
            distance: null,
            recordSeconds: null,
            recordWeightKg: 120,
            recordReps: 5,
            recordedAt: DateTime(2026, 3, 2),
            memo: 'updated',
            presetKey: '5rm',
          );

      expect(repository.updateCalls, 1);
      expect(repository.lastUpdatedId, 'record-id');
      expect(repository.lastUpdatedExerciseName, 'squat');
      expect(repository.lastUpdatedRecordType, WorkoutRecordType.weight);
      expect(repository.lastUpdatedWeight, 120);
      expect(repository.lastUpdatedReps, 5);
    });

    test('deleteRecord forwards id to repository', () async {
      final repository = _FakeWorkoutRecordRepository(
        recordsResponse: const [],
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          getWorkoutRecordsUseCaseProvider.overrideWithValue(
            GetWorkoutRecordsUseCase(repository: repository),
          ),
          createWorkoutRecordUseCaseProvider.overrideWithValue(
            CreateWorkoutRecordUseCase(repository: repository),
          ),
          updateWorkoutRecordUseCaseProvider.overrideWithValue(
            UpdateWorkoutRecordUseCase(repository: repository),
          ),
          deleteWorkoutRecordUseCaseProvider.overrideWithValue(
            DeleteWorkoutRecordUseCase(repository: repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(workoutRecordControllerProvider.notifier)
          .deleteRecord(id: 'record-id');

      expect(repository.deleteCalls, 1);
      expect(repository.lastDeletedId, 'record-id');
    });
  });
}

WorkoutRecordEntity _record({required String id}) {
  return WorkoutRecordEntity(
    id: id,
    exerciseName: 'rowing',
    recordType: WorkoutRecordType.time,
    distance: 2000,
    recordSeconds: 430,
    recordWeightKg: null,
    recordReps: null,
    recordedAt: DateTime(2026, 3, 1),
    memo: '',
  );
}

class _FakeWorkoutRecordRepository implements WorkoutRecordRepository {
  _FakeWorkoutRecordRepository({required this.recordsResponse});

  final List<WorkoutRecordEntity> recordsResponse;

  int getMyRecordsCalls = 0;
  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;

  String? lastCreatedExerciseName;
  WorkoutRecordType? lastCreatedRecordType;
  int? lastCreatedDistance;
  int? lastCreatedRecordSeconds;

  String? lastUpdatedId;
  String? lastUpdatedExerciseName;
  WorkoutRecordType? lastUpdatedRecordType;
  double? lastUpdatedWeight;
  int? lastUpdatedReps;

  String? lastDeletedId;

  @override
  Future<List<WorkoutExerciseEntity>> getExercises({
    required String tenantId,
  }) async {
    return const [];
  }

  @override
  Future<List<WorkoutExercisePresetEntity>> getExercisePresets({
    required String tenantId,
  }) async {
    return const [];
  }

  @override
  Future<List<WorkoutRecordEntity>> getMyRecords({
    required String tenantId,
  }) async {
    getMyRecordsCalls += 1;
    return recordsResponse;
  }

  @override
  Future<void> createMyRecord({
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
  }) async {
    createCalls += 1;
    lastCreatedExerciseName = exerciseName;
    lastCreatedRecordType = recordType;
    lastCreatedDistance = distance;
    lastCreatedRecordSeconds = recordSeconds;
  }

  @override
  Future<void> updateMyRecord({
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
  }) async {
    updateCalls += 1;
    lastUpdatedId = id;
    lastUpdatedExerciseName = exerciseName;
    lastUpdatedRecordType = recordType;
    lastUpdatedWeight = recordWeightKg;
    lastUpdatedReps = recordReps;
  }

  @override
  Future<void> deleteMyRecord({
    required String id,
    required String tenantId,
  }) async {
    deleteCalls += 1;
    lastDeletedId = id;
  }
}
