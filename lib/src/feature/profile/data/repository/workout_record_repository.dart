import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/profile/data/datasource/workout_record_data_source.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';

part 'workout_record_repository.g.dart';

abstract interface class WorkoutRecordRepository {
  Future<List<WorkoutRecordEntity>> getMyRecords({required String tenantId});

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
  });

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
  });

  Future<void> deleteMyRecord({required String id, required String tenantId});
}

class WorkoutRecordRepositoryImpl implements WorkoutRecordRepository {
  WorkoutRecordRepositoryImpl({required this.dataSource});

  final WorkoutRecordDataSource dataSource;

  static const _recordTypeByValue = <String, WorkoutRecordType>{
    'time': WorkoutRecordType.time,
    'weight': WorkoutRecordType.weight,
  };

  static const _recordTypeByEntity = <WorkoutRecordType, String>{
    WorkoutRecordType.time: 'time',
    WorkoutRecordType.weight: 'weight',
  };

  @override
  Future<List<WorkoutRecordEntity>> getMyRecords({
    required String tenantId,
  }) async {
    try {
      final rows = await dataSource.getMyRecords(tenantId: tenantId);
      final items = <WorkoutRecordEntity>[];

      for (final row in rows) {
        final id = row['id'];
        final exerciseName = row['exercise_key'];
        final recordTypeValue = row['record_type'];
        final recordedAtValue = row['recorded_at'];

        if (id is! String ||
            exerciseName is! String ||
            recordTypeValue is! String ||
            recordedAtValue is! String) {
          continue;
        }

        final recordType = _recordTypeByValue[recordTypeValue];
        final recordedAt = DateTime.tryParse(recordedAtValue);

        if (recordType == null || recordedAt == null) {
          continue;
        }

        items.add(
          WorkoutRecordEntity(
            id: id,
            exerciseName: exerciseName,
            recordType: recordType,
            distance: _asInt(row['distance']),
            recordSeconds: _asInt(row['record_seconds']),
            recordWeightKg: _asDouble(row['record_weight_kg']),
            recordReps: _asInt(row['record_reps']),
            recordedAt: DateTime(
              recordedAt.year,
              recordedAt.month,
              recordedAt.day,
            ),
            memo: (row['memo'] as String?)?.trim() ?? '',
          ),
        );
      }

      return items;
    } on AuthException catch (error, stackTrace) {
      debugPrint('[WorkoutRecordRepository] getMyRecords auth failure: $error');
      debugPrint('[WorkoutRecordRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[WorkoutRecordRepository] getMyRecords unexpected failure: $error',
      );
      debugPrint('[WorkoutRecordRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load workout records.',
        cause: error,
      );
    }
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
  }) async {
    try {
      await dataSource.createMyRecord(
        tenantId: tenantId,
        exerciseName: exerciseName,
        recordType: _recordTypeByEntity[recordType]!,
        distance: distance,
        recordSeconds: recordSeconds,
        recordWeightKg: recordWeightKg,
        recordReps: recordReps,
        recordedAt: recordedAt,
        memo: memo,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        '[WorkoutRecordRepository] createMyRecord auth failure: $error',
      );
      debugPrint('[WorkoutRecordRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } on PostgrestException catch (error, stackTrace) {
      debugPrint(
        '[WorkoutRecordRepository] createMyRecord postgrest failure: ${error.message} (code=${error.code}, details=${error.details})',
      );
      debugPrint('[WorkoutRecordRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to save workout record.',
        cause: error,
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[WorkoutRecordRepository] createMyRecord unexpected failure: $error',
      );
      debugPrint('[WorkoutRecordRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to save workout record.',
        cause: error,
      );
    }
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
  }) async {
    try {
      await dataSource.updateMyRecord(
        id: id,
        tenantId: tenantId,
        exerciseName: exerciseName,
        recordType: _recordTypeByEntity[recordType]!,
        distance: distance,
        recordSeconds: recordSeconds,
        recordWeightKg: recordWeightKg,
        recordReps: recordReps,
        recordedAt: recordedAt,
        memo: memo,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        '[WorkoutRecordRepository] updateMyRecord auth failure: $error',
      );
      debugPrint('[WorkoutRecordRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[WorkoutRecordRepository] updateMyRecord unexpected failure: $error',
      );
      debugPrint('[WorkoutRecordRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to update workout record.',
        cause: error,
      );
    }
  }

  @override
  Future<void> deleteMyRecord({
    required String id,
    required String tenantId,
  }) async {
    try {
      await dataSource.deleteMyRecord(id: id, tenantId: tenantId);
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        '[WorkoutRecordRepository] deleteMyRecord auth failure: $error',
      );
      debugPrint('[WorkoutRecordRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[WorkoutRecordRepository] deleteMyRecord unexpected failure: $error',
      );
      debugPrint('[WorkoutRecordRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to delete workout record.',
        cause: error,
      );
    }
  }

  double? _asDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    return null;
  }

  int? _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }
}

@riverpod
WorkoutRecordRepository workoutRecordRepository(Ref ref) {
  return WorkoutRecordRepositoryImpl(
    dataSource: ref.read(workoutRecordDataSourceProvider),
  );
}
