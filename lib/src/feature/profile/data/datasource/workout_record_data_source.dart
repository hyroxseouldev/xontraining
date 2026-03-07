import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'workout_record_data_source.g.dart';

abstract interface class WorkoutRecordDataSource {
  Future<List<Map<String, dynamic>>> getExercises({required String tenantId});

  Future<List<Map<String, dynamic>>> getExercisePresets({
    required String tenantId,
  });

  Future<List<Map<String, dynamic>>> getMyRecords({required String tenantId});

  Future<List<Map<String, dynamic>>> getLeaderboard({
    required String tenantId,
    required String exerciseKey,
    required String presetKey,
    required int limit,
  });

  Future<void> createMyRecord({
    required String tenantId,
    required String exerciseName,
    required String recordType,
    required int? distance,
    required int? recordSeconds,
    required double? recordWeightKg,
    required int? recordReps,
    required DateTime recordedAt,
    required String memo,
    required String? presetKey,
  });

  Future<void> updateMyRecord({
    required String id,
    required String tenantId,
    required String exerciseName,
    required String recordType,
    required int? distance,
    required int? recordSeconds,
    required double? recordWeightKg,
    required int? recordReps,
    required DateTime recordedAt,
    required String memo,
    required String? presetKey,
  });

  Future<void> deleteMyRecord({required String id, required String tenantId});
}

class SupabaseWorkoutRecordDataSource implements WorkoutRecordDataSource {
  SupabaseWorkoutRecordDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<List<Map<String, dynamic>>> getExercises({
    required String tenantId,
  }) async {
    final rows = await supabase
        .from('workout_exercises')
        .select('exercise_key,record_type,sort_order,is_active')
        .eq('tenant_id', tenantId)
        .eq('is_active', true)
        .order('sort_order', ascending: true);

    return rows;
  }

  @override
  Future<List<Map<String, dynamic>>> getExercisePresets({
    required String tenantId,
  }) async {
    final rows = await supabase
        .from('workout_exercise_presets')
        .select(
          'exercise_key,preset_key,distance_m,target_reps,sort_order,is_active',
        )
        .eq('tenant_id', tenantId)
        .eq('is_active', true)
        .order('exercise_key', ascending: true)
        .order('sort_order', ascending: true);

    return rows;
  }

  @override
  Future<List<Map<String, dynamic>>> getMyRecords({
    required String tenantId,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final rows = await supabase
        .from('user_workout_records_v2')
        .select(
          'id,exercise_key,preset_key,record_type,distance,record_seconds,record_weight_kg,record_reps,recorded_at,memo,created_at',
        )
        .eq('tenant_id', tenantId)
        .eq('user_id', userId)
        .order('record_type', ascending: true)
        .order('recorded_at', ascending: false)
        .order('created_at', ascending: false);

    return rows;
  }

  @override
  Future<List<Map<String, dynamic>>> getLeaderboard({
    required String tenantId,
    required String exerciseKey,
    required String presetKey,
    required int limit,
  }) async {
    final rows = await supabase.rpc(
      'get_workout_leaderboard',
      params: {
        'p_tenant_id': tenantId,
        'p_exercise_key': exerciseKey,
        'p_preset_key': presetKey,
        'p_limit': limit,
      },
    );

    return List<Map<String, dynamic>>.from(rows as List);
  }

  @override
  Future<void> createMyRecord({
    required String tenantId,
    required String exerciseName,
    required String recordType,
    required int? distance,
    required int? recordSeconds,
    required double? recordWeightKg,
    required int? recordReps,
    required DateTime recordedAt,
    required String memo,
    required String? presetKey,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase.from('user_workout_records_v2').insert({
      'tenant_id': tenantId,
      'user_id': userId,
      'exercise_key': exerciseName,
      'record_type': recordType,
      'distance': distance,
      'record_seconds': recordSeconds,
      'record_weight_kg': recordWeightKg,
      'record_reps': recordReps,
      'recorded_at': recordedAt.toIso8601String().split('T').first,
      'memo': memo,
      'preset_key': presetKey,
    });
  }

  @override
  Future<void> updateMyRecord({
    required String id,
    required String tenantId,
    required String exerciseName,
    required String recordType,
    required int? distance,
    required int? recordSeconds,
    required double? recordWeightKg,
    required int? recordReps,
    required DateTime recordedAt,
    required String memo,
    required String? presetKey,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase
        .from('user_workout_records_v2')
        .update({
          'exercise_key': exerciseName,
          'record_type': recordType,
          'distance': distance,
          'record_seconds': recordSeconds,
          'record_weight_kg': recordWeightKg,
          'record_reps': recordReps,
          'recorded_at': recordedAt.toIso8601String().split('T').first,
          'memo': memo,
          'preset_key': presetKey,
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
        .from('user_workout_records_v2')
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
