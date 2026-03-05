import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'home_data_source.g.dart';

abstract interface class HomeDataSource {
  Future<List<Map<String, dynamic>>> getProgramsByTenant({
    required String tenantId,
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
}

@riverpod
HomeDataSource homeDataSource(Ref ref) {
  return SupabaseHomeDataSource(supabase: ref.read(supabaseClientProvider));
}
