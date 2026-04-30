import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

part 'program_session_review_data_source.g.dart';

abstract interface class ProgramSessionReviewDataSource {
  Future<List<Map<String, dynamic>>> getMySessionReviewsByProgram({
    required String tenantId,
    required String programId,
  });

  Future<void> createMySessionReview({
    required String tenantId,
    required String programId,
    required String sessionId,
    required String completionNote,
  });

  Future<void> updateMySessionReview({
    required String id,
    required String tenantId,
    required String completionNote,
  });

  Future<List<Map<String, dynamic>>> getCoachSessionReviews({
    required String tenantId,
    String? status,
  });

  Future<void> reviewSessionReview({
    required String id,
    required String tenantId,
    required String coachFeedback,
  });
}

class SupabaseProgramSessionReviewDataSource
    implements ProgramSessionReviewDataSource {
  SupabaseProgramSessionReviewDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  Future<List<Map<String, dynamic>>> getMySessionReviewsByProgram({
    required String tenantId,
    required String programId,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final rows = await supabase
        .from('program_session_reviews')
        .select(
          'id,program_id,session_id,user_id,completion_note,status,coach_feedback,reviewed_by,reviewed_at,created_at,updated_at',
        )
        .eq('tenant_id', tenantId)
        .eq('program_id', programId)
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    final mappedRows = List<Map<String, dynamic>>.from(rows);
    final reviewerIds = mappedRows
        .map((row) => row['reviewed_by'])
        .whereType<String>()
        .toSet()
        .toList(growable: false);
    final profilesById = await _getReviewerProfilesByIds(userIds: reviewerIds);

    for (final row in mappedRows) {
      final reviewedBy = row['reviewed_by'];
      if (reviewedBy is String) {
        row['reviewer_profile'] = profilesById[reviewedBy];
      }
    }

    return mappedRows;
  }

  @override
  Future<void> createMySessionReview({
    required String tenantId,
    required String programId,
    required String sessionId,
    required String completionNote,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase.from('program_session_reviews').insert({
      'tenant_id': tenantId,
      'program_id': programId,
      'session_id': sessionId,
      'user_id': userId,
      'completion_note': completionNote.trim(),
    });
  }

  @override
  Future<void> updateMySessionReview({
    required String id,
    required String tenantId,
    required String completionNote,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    await supabase
        .from('program_session_reviews')
        .update({
          'completion_note': completionNote.trim(),
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', id)
        .eq('tenant_id', tenantId)
        .eq('user_id', userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getCoachSessionReviews({
    required String tenantId,
    String? status,
  }) async {
    var query = supabase
        .from('program_session_reviews')
        .select(
          'id,program_id,session_id,user_id,completion_note,status,coach_feedback,reviewed_by,reviewed_at,created_at,updated_at,programs!inner(title),sessions!inner(title,session_date)',
        );

    query = query.eq('tenant_id', tenantId);
    if (status != null && status.trim().isNotEmpty) {
      query = query.eq('status', status.trim());
    }

    final rows = List<Map<String, dynamic>>.from(
      await query.order('created_at', ascending: false),
    );
    final memberIds = rows
        .map((row) => row['user_id'])
        .whereType<String>()
        .toSet()
        .toList(growable: false);
    final profilesById = await _getMemberProfilesByIds(
      tenantId: tenantId,
      userIds: memberIds,
    );

    for (final row in rows) {
      final userId = row['user_id'];
      if (userId is String) {
        row['member_profile'] = profilesById[userId];
      }
    }

    return rows;
  }

  @override
  Future<void> reviewSessionReview({
    required String id,
    required String tenantId,
    required String coachFeedback,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }

    final nowIso = DateTime.now().toUtc().toIso8601String();

    await supabase
        .from('program_session_reviews')
        .update({
          'coach_feedback': coachFeedback.trim(),
          'status': 'reviewed',
          'reviewed_by': userId,
          'reviewed_at': nowIso,
          'updated_at': nowIso,
        })
        .eq('id', id)
        .eq('tenant_id', tenantId);
  }

  Future<Map<String, Map<String, dynamic>>> _getReviewerProfilesByIds({
    required List<String> userIds,
  }) async {
    if (userIds.isEmpty) {
      return const {};
    }

    final rows = List<Map<String, dynamic>>.from(
      await supabase
          .from('profiles')
          .select('id,full_name,avatar_url')
          .inFilter('id', userIds),
    );

    return {
      for (final row in rows)
        if (row['id'] is String) row['id'] as String: row,
    };
  }

  Future<Map<String, Map<String, dynamic>>> _getMemberProfilesByIds({
    required String tenantId,
    required List<String> userIds,
  }) async {
    if (userIds.isEmpty) {
      return const {};
    }

    final rows = List<Map<String, dynamic>>.from(
      await supabase
          .from('tenant_user_profiles')
          .select('user_id,display_name,avatar_url')
          .eq('tenant_id', tenantId)
          .inFilter('user_id', userIds),
    );

    return {
      for (final row in rows)
        if (row['user_id'] is String) row['user_id'] as String: row,
    };
  }
}

@riverpod
ProgramSessionReviewDataSource programSessionReviewDataSource(Ref ref) {
  return SupabaseProgramSessionReviewDataSource(
    supabase: ref.read(supabaseClientProvider),
  );
}
