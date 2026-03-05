import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'notice_data_source.g.dart';

abstract interface class NoticeDataSource {
  Future<List<Map<String, dynamic>>> getNoticesPage({
    required String tenantId,
    required int limit,
    required int offset,
  });

  Future<Map<String, dynamic>?> getNoticeById({
    required String tenantId,
    required String noticeId,
  });
}

class SupabaseNoticeDataSource implements NoticeDataSource {
  SupabaseNoticeDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<List<Map<String, dynamic>>> getNoticesPage({
    required String tenantId,
    required int limit,
    required int offset,
  }) async {
    final rows = await supabase
        .from('notices')
        .select('id,title,content_html,thumbnail_url,created_at')
        .eq('tenant_id', tenantId)
        .eq('is_published', true)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return rows;
  }

  @override
  Future<Map<String, dynamic>?> getNoticeById({
    required String tenantId,
    required String noticeId,
  }) async {
    final row = await supabase
        .from('notices')
        .select('id,title,content_html,thumbnail_url,created_at')
        .eq('tenant_id', tenantId)
        .eq('id', noticeId)
        .eq('is_published', true)
        .maybeSingle();

    return row;
  }
}

@riverpod
NoticeDataSource noticeDataSource(Ref ref) {
  return SupabaseNoticeDataSource(supabase: ref.read(supabaseClientProvider));
}
