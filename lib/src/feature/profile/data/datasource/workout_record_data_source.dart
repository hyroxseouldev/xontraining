import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'workout_record_data_source.g.dart';

abstract interface class WorkoutRecordDataSource {
  Future<List<Map<String, dynamic>>> getMyRecords({required String tenantId});

  Future<void> createMyRecord({
    required String tenantId,
    required String exerciseName,
    required String metricType,
    required double? valueNumeric,
    required int? valueSeconds,
    required String unit,
    required DateTime recordedAt,
    required String memo,
  });

  Future<void> updateMyRecord({
    required String id,
    required String tenantId,
    required String exerciseName,
    required String metricType,
    required double? valueNumeric,
    required int? valueSeconds,
    required String unit,
    required DateTime recordedAt,
    required String memo,
  });

  Future<void> deleteMyRecord({required String id, required String tenantId});
}

class SupabaseWorkoutRecordDataSource implements WorkoutRecordDataSource {
  SupabaseWorkoutRecordDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<List<Map<String, dynamic>>> getMyRecords({
    required String tenantId,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final rows = await supabase
        .from('user_personal_records')
        .select(
          'id,exercise_name,metric_type,value_numeric,value_seconds,unit,recorded_at,memo,created_at',
        )
        .eq('tenant_id', tenantId)
        .eq('user_id', userId)
        .order('recorded_at', ascending: false)
        .order('created_at', ascending: false);

    return rows;
  }

  @override
  Future<void> createMyRecord({
    required String tenantId,
    required String exerciseName,
    required String metricType,
    required double? valueNumeric,
    required int? valueSeconds,
    required String unit,
    required DateTime recordedAt,
    required String memo,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase.from('user_personal_records').insert({
      'tenant_id': tenantId,
      'user_id': userId,
      'exercise_name': exerciseName,
      'metric_type': metricType,
      'value_numeric': valueNumeric,
      'value_seconds': valueSeconds,
      'unit': unit,
      'recorded_at': recordedAt.toIso8601String().split('T').first,
      'memo': memo,
    });
  }

  @override
  Future<void> updateMyRecord({
    required String id,
    required String tenantId,
    required String exerciseName,
    required String metricType,
    required double? valueNumeric,
    required int? valueSeconds,
    required String unit,
    required DateTime recordedAt,
    required String memo,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase
        .from('user_personal_records')
        .update({
          'exercise_name': exerciseName,
          'metric_type': metricType,
          'value_numeric': valueNumeric,
          'value_seconds': valueSeconds,
          'unit': unit,
          'recorded_at': recordedAt.toIso8601String().split('T').first,
          'memo': memo,
        })
        .eq('id', id)
        .eq('tenant_id', tenantId)
        .eq('user_id', userId);
  }

  @override
  Future<void> deleteMyRecord({
    required String id,
    required String tenantId,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase
        .from('user_personal_records')
        .delete()
        .eq('id', id)
        .eq('tenant_id', tenantId)
        .eq('user_id', userId);
  }
}

@riverpod
WorkoutRecordDataSource workoutRecordDataSource(Ref ref) {
  return SupabaseWorkoutRecordDataSource(
    supabase: ref.read(supabaseClientProvider),
  );
}
