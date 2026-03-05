import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'home_data_source.g.dart';

abstract interface class HomeDataSource {
  Future<Map<String, dynamic>?> getCurrentActiveProgram();
  Future<List<Map<String, dynamic>>> getBlueprintSectionsByDate({
    required String programId,
    required DateTime date,
  });
}

class SupabaseHomeDataSource implements HomeDataSource {
  SupabaseHomeDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<Map<String, dynamic>?> getCurrentActiveProgram() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final userProgramState = await supabase
        .from('user_program_states')
        .select('active_program_id')
        .eq('user_id', userId)
        .maybeSingle();
    final activeProgramId = userProgramState?['active_program_id'];

    if (activeProgramId is String && activeProgramId.isNotEmpty) {
      return await supabase
          .from('programs')
          .select('id,title,logo_url,description')
          .eq('id', activeProgramId)
          .maybeSingle();
    }

    final entitlement = await supabase
        .from('program_entitlements')
        .select('program_id,starts_at,created_at')
        .eq('user_id', userId)
        .eq('is_active', true)
        .or('ends_at.is.null,ends_at.gte.now()')
        .order('starts_at', ascending: false)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    final fallbackProgramId = entitlement?['program_id'];
    if (fallbackProgramId is! String || fallbackProgramId.isEmpty) {
      return null;
    }

    return await supabase
        .from('programs')
        .select('id,title,logo_url,description')
        .eq('id', fallbackProgramId)
        .maybeSingle();
  }

  @override
  Future<List<Map<String, dynamic>>> getBlueprintSectionsByDate({
    required String programId,
    required DateTime date,
  }) async {
    final dateOnly = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String().split('T').first;
    final rows = await supabase
        .from('sessions')
        .select('id,title,content_html,session_date,created_at')
        .eq('program_id', programId)
        .eq('session_date', dateOnly)
        .order('created_at', ascending: true);

    return rows;
  }
}

@riverpod
HomeDataSource homeDataSource(Ref ref) {
  return SupabaseHomeDataSource(supabase: ref.read(supabaseClientProvider));
}
