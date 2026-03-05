import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'home_data_source.g.dart';

abstract interface class HomeDataSource {
  Future<List<Map<String, dynamic>>> getProgramsByTenant({
    required String tenantId,
  });

  Future<bool> hasProgramAccess({
    required String tenantId,
    required String userId,
    required String programId,
  });

  Future<List<Map<String, dynamic>>> getSessionsByProgram({
    required String tenantId,
    required String programId,
  });
}

class SupabaseHomeDataSource implements HomeDataSource {
  SupabaseHomeDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<List<Map<String, dynamic>>> getProgramsByTenant({
    required String tenantId,
  }) async {
    final rows = await supabase
        .from('programs')
        .select(
          'id,title,description,thumbnail_url,difficulty,daily_workout_minutes,days_per_week,start_date,end_date,created_at',
        )
        .eq('tenant_id', tenantId)
        .order('created_at', ascending: false);

    return rows;
  }

  @override
  Future<bool> hasProgramAccess({
    required String tenantId,
    required String userId,
    required String programId,
  }) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();

    final entitlement = await supabase
        .from('program_entitlements')
        .select('id')
        .eq('tenant_id', tenantId)
        .eq('user_id', userId)
        .eq('program_id', programId)
        .eq('is_active', true)
        .lte('starts_at', nowIso)
        .or('ends_at.is.null,ends_at.gte.$nowIso')
        .limit(1)
        .maybeSingle();

    if (entitlement != null) {
      return true;
    }

    final activeState = await supabase
        .from('user_program_states')
        .select('active_program_id')
        .eq('tenant_id', tenantId)
        .eq('user_id', userId)
        .eq('active_program_id', programId)
        .maybeSingle();

    return activeState != null;
  }

  @override
  Future<List<Map<String, dynamic>>> getSessionsByProgram({
    required String tenantId,
    required String programId,
  }) async {
    final rows = await supabase
        .from('sessions')
        .select('id,session_date,week,day_label,title,content_html')
        .eq('tenant_id', tenantId)
        .eq('program_id', programId)
        .order('session_date', ascending: true);

    return rows;
  }
}

@riverpod
HomeDataSource homeDataSource(Ref ref) {
  return SupabaseHomeDataSource(supabase: ref.read(supabaseClientProvider));
}
