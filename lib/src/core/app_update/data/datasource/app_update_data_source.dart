import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

abstract interface class AppUpdateDataSource {
  Future<Map<String, dynamic>?> getActivePolicy({required String platform});
}

class SupabaseAppUpdateDataSource implements AppUpdateDataSource {
  SupabaseAppUpdateDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<Map<String, dynamic>?> getActivePolicy({required String platform}) {
    return supabase
        .from('app_version_policies')
        .select('platform,minimum_version,store_url,is_active')
        .eq('platform', platform)
        .eq('is_active', true)
        .maybeSingle();
  }
}

final appUpdateDataSourceProvider = Provider<AppUpdateDataSource>((ref) {
  return SupabaseAppUpdateDataSource(
    supabase: ref.read(supabaseClientProvider),
  );
});
