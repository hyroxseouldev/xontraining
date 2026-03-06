import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/community/data/datasource/community_data_source.dart';
import 'package:xontraining/src/feature/community/infra/entity/community_entity.dart';

abstract interface class CommunityRepository {
  Future<List<CommunityPostEntity>> getPostsPage({
    required String tenantId,
    required int limit,
    required int offset,
  });

  Future<CommunityPostEntity> getPostDetail({
    required String tenantId,
    required String postId,
  });

  Future<List<CommunityCommentEntity>> getComments({
    required String tenantId,
    required String postId,
  });

  Future<void> createPost({
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

  Future<void> deletePost({required String tenantId, required String postId});

  Future<void> createComment({
    required String tenantId,
    required String postId,
    required String content,
  });

  Future<void> deleteComment({
    required String tenantId,
    required String commentId,
  });

  Future<void> setPostLiked({
    required String tenantId,
    required String postId,
    required bool like,
  });
}

class CommunityRepositoryImpl implements CommunityRepository {
  CommunityRepositoryImpl({required this.dataSource});

  final CommunityDataSource dataSource;

  @override
  Future<List<CommunityPostEntity>> getPostsPage({
    required String tenantId,
    required int limit,
    required int offset,
  }) async {
    try {
      final userId = dataSource.getCurrentUserId();
      final rows = await dataSource.getPostsPage(
        tenantId: tenantId,
        limit: limit,
        offset: offset,
      );
      final posts = <CommunityPostEntity>[];
      final postIds = <String>[];
      final authorIds = <String>{};

      for (final row in rows) {
        final post = _mapPostRow(row);
        if (post == null) {
          continue;
        }
        posts.add(post);
        postIds.add(post.id);
        authorIds.add(post.authorId);
      }

      final likesRows = await dataSource.getLikesByPostIds(
        tenantId: tenantId,
        postIds: postIds,
      );
      final commentRows = await dataSource.getCommentsByPostIds(
        tenantId: tenantId,
        postIds: postIds,
      );
      final profileRows = await dataSource.getProfilesByIds(
        userIds: authorIds.toList(growable: false),
      );

      final likesByPost = <String, int>{};
      final likedByMe = <String>{};
      for (final row in likesRows) {
        final postId = row['post_id'];
        final likerId = row['user_id'];
        if (postId is! String || likerId is! String) {
          continue;
        }
        likesByPost.update(postId, (value) => value + 1, ifAbsent: () => 1);
        if (likerId == userId) {
          likedByMe.add(postId);
        }
      }

      final commentsByPost = <String, int>{};
      for (final row in commentRows) {
        final postId = row['post_id'];
        if (postId is! String) {
          continue;
        }
        commentsByPost.update(postId, (value) => value + 1, ifAbsent: () => 1);
      }

      final namesByUserId = <String, String>{};
      final avatarsByUserId = <String, String>{};
      for (final row in profileRows) {
        final id = row['id'];
        final fullName = row['full_name'];
        final avatarUrl = row['avatar_url'];
        if (id is String && fullName is String) {
          namesByUserId[id] = fullName;
        }
        if (id is String && avatarUrl is String) {
          avatarsByUserId[id] = avatarUrl;
        }
      }

      return posts
          .map(
            (post) => post.copyWith(
              likeCount: likesByPost[post.id] ?? 0,
              commentCount: commentsByPost[post.id] ?? 0,
              isLikedByMe: likedByMe.contains(post.id),
            ),
          )
          .map(
            (post) => CommunityPostEntity(
              id: post.id,
              authorId: post.authorId,
              authorName: namesByUserId[post.authorId] ?? '',
              authorAvatarUrl: avatarsByUserId[post.authorId] ?? '',
              content: post.content,
              imageUrls: post.imageUrls,
              createdAt: post.createdAt,
              updatedAt: post.updatedAt,
              likeCount: post.likeCount,
              commentCount: post.commentCount,
              isLikedByMe: post.isLikedByMe,
            ),
          )
          .toList(growable: false);
    } on AuthException catch (error, stackTrace) {
      debugPrint('[CommunityRepository] getPostsPage auth failure: $error');
      debugPrint('[CommunityRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[CommunityRepository] getPostsPage unexpected failure: $error',
      );
      debugPrint('[CommunityRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load community posts.',
        cause: error,
      );
    }
  }

  @override
  Future<CommunityPostEntity> getPostDetail({
    required String tenantId,
    required String postId,
  }) async {
    try {
      final userId = dataSource.getCurrentUserId();
      final row = await dataSource.getPostById(
        tenantId: tenantId,
        postId: postId,
      );
      if (row == null) {
        throw const AppException.unknown(message: 'Post not found.');
      }

      final post = _mapPostRow(row);
      if (post == null) {
        throw const AppException.unknown(message: 'Post has invalid schema.');
      }

      final likesRows = await dataSource.getLikesByPostIds(
        tenantId: tenantId,
        postIds: [post.id],
      );
      final commentRows = await dataSource.getCommentsByPostIds(
        tenantId: tenantId,
        postIds: [post.id],
      );
      final profileRows = await dataSource.getProfilesByIds(
        userIds: [post.authorId],
      );

      var likeCount = 0;
      var isLikedByMe = false;
      for (final likeRow in likesRows) {
        final likerId = likeRow['user_id'];
        likeCount += 1;
        if (likerId is String && likerId == userId) {
          isLikedByMe = true;
        }
      }

      final commentCount = commentRows.length;
      final fullName =
          profileRows.isNotEmpty && profileRows.first['full_name'] is String
          ? profileRows.first['full_name'] as String
          : '';
      final avatarUrl =
          profileRows.isNotEmpty && profileRows.first['avatar_url'] is String
          ? profileRows.first['avatar_url'] as String
          : '';

      return CommunityPostEntity(
        id: post.id,
        authorId: post.authorId,
        authorName: fullName,
        authorAvatarUrl: avatarUrl,
        content: post.content,
        imageUrls: post.imageUrls,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
        likeCount: likeCount,
        commentCount: commentCount,
        isLikedByMe: isLikedByMe,
      );
    } on AppException {
      rethrow;
    } on AuthException catch (error, stackTrace) {
      debugPrint('[CommunityRepository] getPostDetail auth failure: $error');
      debugPrint('[CommunityRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[CommunityRepository] getPostDetail unexpected failure: $error',
      );
      debugPrint('[CommunityRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load post detail.',
        cause: error,
      );
    }
  }

  @override
  Future<List<CommunityCommentEntity>> getComments({
    required String tenantId,
    required String postId,
  }) async {
    try {
      final rows = await dataSource.getCommentsByPostId(
        tenantId: tenantId,
        postId: postId,
      );
      final comments = <CommunityCommentEntity>[];
      final userIds = <String>{};

      for (final row in rows) {
        final comment = _mapCommentRow(row);
        if (comment == null) {
          continue;
        }
        comments.add(comment);
        userIds.add(comment.authorId);
      }

      final profileRows = await dataSource.getProfilesByIds(
        userIds: userIds.toList(growable: false),
      );
      final namesByUserId = <String, String>{};
      final avatarsByUserId = <String, String>{};
      for (final row in profileRows) {
        final id = row['id'];
        final fullName = row['full_name'];
        final avatarUrl = row['avatar_url'];
        if (id is String && fullName is String) {
          namesByUserId[id] = fullName;
        }
        if (id is String && avatarUrl is String) {
          avatarsByUserId[id] = avatarUrl;
        }
      }

      return comments
          .map(
            (comment) => CommunityCommentEntity(
              id: comment.id,
              postId: comment.postId,
              authorId: comment.authorId,
              authorName: namesByUserId[comment.authorId] ?? '',
              authorAvatarUrl: avatarsByUserId[comment.authorId] ?? '',
              content: comment.content,
              createdAt: comment.createdAt,
              updatedAt: comment.updatedAt,
            ),
          )
          .toList(growable: false);
    } on AuthException catch (error, stackTrace) {
      debugPrint('[CommunityRepository] getComments auth failure: $error');
      debugPrint('[CommunityRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[CommunityRepository] getComments unexpected failure: $error',
      );
      debugPrint('[CommunityRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load comments.',
        cause: error,
      );
    }
  }

  @override
  Future<void> createPost({
    required String tenantId,
    required String content,
    required List<String> imageUrls,
  }) async {
    await _guard(() async {
      await dataSource.createPost(
        tenantId: tenantId,
        content: content,
        imageUrls: imageUrls,
      );
    }, defaultMessage: 'Failed to create post.');
  }

  @override
  Future<void> updatePost({
    required String tenantId,
    required String postId,
    required String content,
    required List<String> imageUrls,
  }) async {
    await _guard(() async {
      await dataSource.updatePost(
        tenantId: tenantId,
        postId: postId,
        content: content,
        imageUrls: imageUrls,
      );
    }, defaultMessage: 'Failed to update post.');
  }

  @override
  Future<void> deletePost({
    required String tenantId,
    required String postId,
  }) async {
    await _guard(() async {
      await dataSource.softDeletePost(tenantId: tenantId, postId: postId);
    }, defaultMessage: 'Failed to delete post.');
  }

  @override
  Future<void> createComment({
    required String tenantId,
    required String postId,
    required String content,
  }) async {
    await _guard(() async {
      await dataSource.createComment(
        tenantId: tenantId,
        postId: postId,
        content: content,
      );
    }, defaultMessage: 'Failed to create comment.');
  }

  @override
  Future<void> deleteComment({
    required String tenantId,
    required String commentId,
  }) async {
    await _guard(() async {
      await dataSource.softDeleteComment(
        tenantId: tenantId,
        commentId: commentId,
      );
    }, defaultMessage: 'Failed to delete comment.');
  }

  @override
  Future<void> setPostLiked({
    required String tenantId,
    required String postId,
    required bool like,
  }) async {
    await _guard(() async {
      await dataSource.setPostLiked(
        tenantId: tenantId,
        postId: postId,
        like: like,
      );
    }, defaultMessage: 'Failed to update like.');
  }

  Future<void> _guard(
    Future<void> Function() action, {
    required String defaultMessage,
  }) async {
    try {
      await action();
    } on AuthException catch (error, stackTrace) {
      debugPrint('[CommunityRepository] auth failure: $error');
      debugPrint('[CommunityRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('[CommunityRepository] unexpected failure: $error');
      debugPrint('[CommunityRepository] StackTrace: $stackTrace');
      throw AppException.unknown(message: defaultMessage, cause: error);
    }
  }

  CommunityPostEntity? _mapPostRow(Map<String, dynamic> row) {
    final id = row['id'];
    final authorId = row['author_id'];
    final content = row['content_html'];
    final images = row['images'];
    final createdAtRaw = row['created_at'];
    final updatedAtRaw = row['updated_at'];
    if (id is! String ||
        authorId is! String ||
        content is! String ||
        images is! List ||
        createdAtRaw is! String ||
        updatedAtRaw is! String) {
      return null;
    }

    final createdAt = DateTime.tryParse(createdAtRaw);
    final updatedAt = DateTime.tryParse(updatedAtRaw);
    if (createdAt == null || updatedAt == null) {
      return null;
    }

    final imageUrls = <String>[];
    for (final image in images) {
      if (image is String && image.trim().isNotEmpty) {
        imageUrls.add(image);
      }
    }

    return CommunityPostEntity(
      id: id,
      authorId: authorId,
      authorName: '',
      authorAvatarUrl: '',
      content: content,
      imageUrls: imageUrls,
      createdAt: createdAt,
      updatedAt: updatedAt,
      likeCount: 0,
      commentCount: 0,
      isLikedByMe: false,
    );
  }

  CommunityCommentEntity? _mapCommentRow(Map<String, dynamic> row) {
    final id = row['id'];
    final postId = row['post_id'];
    final authorId = row['author_id'];
    final content = row['content_html'];
    final createdAtRaw = row['created_at'];
    final updatedAtRaw = row['updated_at'];
    if (id is! String ||
        postId is! String ||
        authorId is! String ||
        content is! String ||
        createdAtRaw is! String ||
        updatedAtRaw is! String) {
      return null;
    }

    final createdAt = DateTime.tryParse(createdAtRaw);
    final updatedAt = DateTime.tryParse(updatedAtRaw);
    if (createdAt == null || updatedAt == null) {
      return null;
    }

    return CommunityCommentEntity(
      id: id,
      postId: postId,
      authorId: authorId,
      authorName: '',
      authorAvatarUrl: '',
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImpl(
    dataSource: ref.read(communityDataSourceProvider),
  );
});
