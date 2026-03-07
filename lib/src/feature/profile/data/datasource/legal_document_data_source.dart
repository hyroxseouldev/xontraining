import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

abstract interface class LegalDocumentDataSource {
  Future<Map<String, dynamic>?> getPublishedDocument({
    required String tenantId,
    required String type,
    required String locale,
  });
}

class SupabaseLegalDocumentDataSource implements LegalDocumentDataSource {
  SupabaseLegalDocumentDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<Map<String, dynamic>?> getPublishedDocument({
    required String tenantId,
    required String type,
    required String locale,
  }) async {
    final row = await supabase
        .from('legal_documents')
        .select(
          'type,locale,title,content_html,version,updated_at,published_at',
        )
        .eq('tenant_id', tenantId)
        .eq('type', type)
        .eq('locale', locale)
        .eq('is_published', true)
        .order('published_at', ascending: false)
        .order('updated_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return row;
  }
}

final legalDocumentDataSourceProvider = Provider<LegalDocumentDataSource>((
  ref,
) {
  return SupabaseLegalDocumentDataSource(
    supabase: ref.read(supabaseClientProvider),
  );
});
