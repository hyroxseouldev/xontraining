import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/supabase/supabase_provider.dart';

abstract interface class CommunityDataSource {
  String getCurrentUserId();

  Future<bool> hasCommunityAccess({
    required String tenantId,
    required String userId,
  });

  Future<List<Map<String, dynamic>>> getPostsPage({
    required String tenantId,
    required int limit,
    required int offset,
  });

  Future<Map<String, dynamic>?> getPostById({
    required String tenantId,
    required String postId,
  });

  Future<List<Map<String, dynamic>>> getCommentsByPostId({
    required String tenantId,
    required String postId,
  });

  Future<List<Map<String, dynamic>>> getProfilesByIds({
    required List<String> userIds,
  });

  Future<List<Map<String, dynamic>>> getLikesByPostIds({
    required String tenantId,
    required List<String> postIds,
  });

  Future<List<Map<String, dynamic>>> getCommentsByPostIds({
    required String tenantId,
    required List<String> postIds,
  });

  Future<Map<String, dynamic>> createPost({
    required String tenantId,
    required String content,
    required List<String> imageUrls,
  });

  Future<void> updatePost({
    required String tenantId,
    required String postId,
    required String content,
    required List<String> imageUrls,
  });

  Future<void> softDeletePost({
    required String tenantId,
    required String postId,
  });

  Future<void> createComment({
    required String tenantId,
    required String postId,
    required String content,
  });

  Future<void> softDeleteComment({
    required String tenantId,
    required String commentId,
  });

  Future<void> setPostLiked({
    required String tenantId,
    required String postId,
    required bool like,
  });

  Future<void> createPostReport({
    required String tenantId,
    required String postId,
    required String reason,
    required String detail,
  });

  Future<void> createCommentReport({
    required String tenantId,
    required String commentId,
    required String reason,
    required String detail,
  });

  Future<void> hidePost({required String tenantId, required String postId});

  Future<void> blockUser({
    required String tenantId,
    required String blockedUserId,
  });

  Future<Set<String>> getHiddenPostIds({
    required String tenantId,
    required String userId,
  });

  Future<Set<String>> getBlockedUserIds({
    required String tenantId,
    required String userId,
  });
}

class SupabaseCommunityDataSource implements CommunityDataSource {
  SupabaseCommunityDataSource({required this.supabase});

  final SupabaseClient supabase;

  @override
  String getCurrentUserId() {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw AuthException('No authenticated user found.');
    }
    return userId;
  }

  @override
  Future<bool> hasCommunityAccess({
    required String tenantId,
    required String userId,
  }) async {
    final nowIso = DateTime.now().toUtc().toIso8601String();

    final entitlement = await supabase
        .from('program_entitlements')
        .select('id')
        .eq('tenant_id', tenantId)
        .eq('user_id', userId)
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
        .not('active_program_id', 'is', null)
        .maybeSingle();

    return activeState != null;
  }

  @override
  Future<List<Map<String, dynamic>>> getPostsPage({
    required String tenantId,
    required int limit,
    required int offset,
  }) async {
    final rows = await supabase
        .from('community_posts')
        .select(
          'id,tenant_id,author_id,content_html,images,status,created_at,updated_at',
        )
        .eq('tenant_id', tenantId)
        .eq('status', 'published')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Future<Map<String, dynamic>?> getPostById({
    required String tenantId,
    required String postId,
  }) async {
    final row = await supabase
        .from('community_posts')
        .select(
          'id,tenant_id,author_id,content_html,images,status,created_at,updated_at',
        )
        .eq('tenant_id', tenantId)
        .eq('id', postId)
        .eq('status', 'published')
        .maybeSingle();

    if (row == null) {
      return null;
    }

    return Map<String, dynamic>.from(row);
  }

  @override
  Future<List<Map<String, dynamic>>> getCommentsByPostId({
    required String tenantId,
    required String postId,
  }) async {
    final rows = await supabase
        .from('community_comments')
        .select(
          'id,tenant_id,post_id,author_id,content_html,status,created_at,updated_at',
        )
        .eq('tenant_id', tenantId)
        .eq('post_id', postId)
        .eq('status', 'published')
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Future<List<Map<String, dynamic>>> getProfilesByIds({
    required List<String> userIds,
  }) async {
    if (userIds.isEmpty) {
      return const [];
    }

    final rows = await supabase
        .from('profiles')
        .select('id,full_name,avatar_url')
        .inFilter('id', userIds);

    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Future<List<Map<String, dynamic>>> getLikesByPostIds({
    required String tenantId,
    required List<String> postIds,
  }) async {
    if (postIds.isEmpty) {
      return const [];
    }

    final rows = await supabase
        .from('community_post_likes')
        .select('post_id,user_id')
        .eq('tenant_id', tenantId)
        .inFilter('post_id', postIds);

    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Future<List<Map<String, dynamic>>> getCommentsByPostIds({
    required String tenantId,
    required List<String> postIds,
  }) async {
    if (postIds.isEmpty) {
      return const [];
    }

    final rows = await supabase
        .from('community_comments')
        .select('post_id')
        .eq('tenant_id', tenantId)
        .eq('status', 'published')
        .inFilter('post_id', postIds);

    return List<Map<String, dynamic>>.from(rows);
  }

  @override
  Future<Map<String, dynamic>> createPost({
    required String tenantId,
    required String content,
    required List<String> imageUrls,
  }) async {
    final userId = getCurrentUserId();

    final row = await supabase
        .from('community_posts')
        .insert({
          'tenant_id': tenantId,
          'author_id': userId,
          'title': '',
          'content_html': content,
          'images': imageUrls,
          'status': 'published',
        })
        .select(
          'id,tenant_id,author_id,content_html,images,status,created_at,updated_at',
        )
        .single();

    return Map<String, dynamic>.from(row);
  }

  @override
  Future<void> updatePost({
    required String tenantId,
    required String postId,
    required String content,
    required List<String> imageUrls,
  }) async {
    await supabase
        .from('community_posts')
        .update({'title': '', 'content_html': content, 'images': imageUrls})
        .eq('tenant_id', tenantId)
        .eq('id', postId);
  }

  @override
  Future<void> softDeletePost({
    required String tenantId,
    required String postId,
  }) async {
    await supabase
        .from('community_posts')
        .update({'status': 'deleted', 'content_html': ''})
        .eq('tenant_id', tenantId)
        .eq('id', postId);
  }

  @override
  Future<void> createComment({
    required String tenantId,
    required String postId,
    required String content,
  }) async {
    final userId = getCurrentUserId();

    await supabase.from('community_comments').insert({
      'tenant_id': tenantId,
      'post_id': postId,
      'author_id': userId,
      'content_html': content,
      'status': 'published',
    });
  }

  @override
  Future<void> softDeleteComment({
    required String tenantId,
    required String commentId,
  }) async {
    await supabase
        .from('community_comments')
        .update({'status': 'deleted', 'content_html': ''})
        .eq('tenant_id', tenantId)
        .eq('id', commentId);
  }

  @override
  Future<void> setPostLiked({
    required String tenantId,
    required String postId,
    required bool like,
  }) async {
    final userId = getCurrentUserId();

    if (like) {
      await supabase.from('community_post_likes').upsert({
        'tenant_id': tenantId,
        'post_id': postId,
        'user_id': userId,
      });
      return;
    }

    await supabase
        .from('community_post_likes')
        .delete()
        .eq('tenant_id', tenantId)
        .eq('post_id', postId)
        .eq('user_id', userId);
  }

  @override
  Future<void> createPostReport({
    required String tenantId,
    required String postId,
    required String reason,
    required String detail,
  }) async {
    final userId = getCurrentUserId();

    await supabase
        .from('community_post_reports')
        .upsert(
          {
            'tenant_id': tenantId,
            'post_id': postId,
            'reporter_id': userId,
            'reason': reason,
            'detail': detail,
            'status': 'pending',
          },
          onConflict: 'tenant_id,post_id,reporter_id',
          ignoreDuplicates: true,
        );
  }

  @override
  Future<void> createCommentReport({
    required String tenantId,
    required String commentId,
    required String reason,
    required String detail,
  }) async {
    final userId = getCurrentUserId();

    await supabase
        .from('community_comment_reports')
        .upsert(
          {
            'tenant_id': tenantId,
            'comment_id': commentId,
            'reporter_id': userId,
            'reason': reason,
            'detail': detail,
            'status': 'pending',
          },
          onConflict: 'tenant_id,comment_id,reporter_id',
          ignoreDuplicates: true,
        );
  }

  @override
  Future<void> hidePost({
    required String tenantId,
    required String postId,
  }) async {
    final userId = getCurrentUserId();

    await supabase
        .from('community_hidden_posts')
        .upsert(
          {'tenant_id': tenantId, 'user_id': userId, 'post_id': postId},
          onConflict: 'tenant_id,user_id,post_id',
          ignoreDuplicates: true,
        );
  }

  @override
  Future<void> blockUser({
    required String tenantId,
    required String blockedUserId,
  }) async {
    final userId = getCurrentUserId();

    await supabase
        .from('community_user_blocks')
        .upsert(
          {
            'tenant_id': tenantId,
            'blocker_id': userId,
            'blocked_user_id': blockedUserId,
          },
          onConflict: 'tenant_id,blocker_id,blocked_user_id',
          ignoreDuplicates: true,
        );
  }

  @override
  Future<Set<String>> getHiddenPostIds({
    required String tenantId,
    required String userId,
  }) async {
    final rows = await supabase
        .from('community_hidden_posts')
        .select('post_id')
        .eq('tenant_id', tenantId)
        .eq('user_id', userId);

    return rows
        .map((row) => row['post_id'])
        .whereType<String>()
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  @override
  Future<Set<String>> getBlockedUserIds({
    required String tenantId,
    required String userId,
  }) async {
    final rows = await supabase
        .from('community_user_blocks')
        .select('blocked_user_id')
        .eq('tenant_id', tenantId)
        .eq('blocker_id', userId);

    return rows
        .map((row) => row['blocked_user_id'])
        .whereType<String>()
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet();
  }
}

final communityDataSourceProvider = Provider<CommunityDataSource>((ref) {
  return SupabaseCommunityDataSource(
    supabase: ref.read(supabaseClientProvider),
  );
});
