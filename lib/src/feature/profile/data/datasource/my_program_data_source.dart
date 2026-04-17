import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

abstract interface class MyProgramDataSource {
  Future<String?> getActiveProgramId({
    required String tenantId,
    required String userId,
  });

  Future<List<Map<String, dynamic>>> getAccessibleProgramEntitlements({
    required String tenantId,
    required String userId,
  });
}

class SupabaseMyProgramDataSource implements MyProgramDataSource {
  SupabaseMyProgramDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<String?> getActiveProgramId({
    required String tenantId,
    required String userId,
  }) async {
    final row = await supabase
        .from('user_program_states')
        .select('active_program_id')
        .eq('tenant_id', tenantId)
        .eq('user_id', userId)
        .maybeSingle();

    final activeProgramId = row?['active_program_id'];
    if (activeProgramId is String && activeProgramId.trim().isNotEmpty) {
      return activeProgramId;
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> getAccessibleProgramEntitlements({
    required String tenantId,
    required String userId,
  }) async {
    final rows = await supabase
        .from('program_entitlements')
        .select(
          'program_id,is_active,starts_at,ends_at,programs!inner(id,title,description,thumbnail_url,difficulty,daily_workout_minutes,days_per_week,start_date,end_date,created_at,display_order)',
        )
        .eq('tenant_id', tenantId)
        .eq('user_id', userId)
        .order('starts_at', ascending: false);

    return List<Map<String, dynamic>>.from(rows);
  }
}

final myProgramDataSourceProvider = Provider<MyProgramDataSource>((ref) {
  return SupabaseMyProgramDataSource(
    supabase: ref.read(supabaseClientProvider),
  );
});
