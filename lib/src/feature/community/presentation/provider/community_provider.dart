import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/storage/storage_service.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/community/infra/entity/community_entity.dart';
import 'package:xontraining/src/feature/community/infra/usecase/community_usecases.dart';

const _communityPageSize = 10;

class CommunityFeedState {
  const CommunityFeedState({
    required this.items,
    required this.offset,
    required this.hasMore,
    required this.isLoadingMore,
    required this.hasLoadMoreError,
  });

  final List<CommunityPostEntity> items;
  final int offset;
  final bool hasMore;
  final bool isLoadingMore;
  final bool hasLoadMoreError;

  CommunityFeedState copyWith({
    List<CommunityPostEntity>? items,
    int? offset,
    bool? hasMore,
    bool? isLoadingMore,
    bool? hasLoadMoreError,
  }) {
    return CommunityFeedState(
      items: items ?? this.items,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasLoadMoreError: hasLoadMoreError ?? this.hasLoadMoreError,
    );
  }
}

class CommunityFeedController extends AsyncNotifier<CommunityFeedState> {
  @override
  Future<CommunityFeedState> build() async {
    return _loadInitial();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadInitial);
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null ||
        current.isLoadingMore ||
        current.hasLoadMoreError ||
        !current.hasMore) {
      return;
    }

    state = AsyncData(
      current.copyWith(isLoadingMore: true, hasLoadMoreError: false),
    );

    try {
      final tenantId = ref.read(tenantIdProvider);
      final nextItems = await ref
          .read(getCommunityPostsPageUseCaseProvider)
          .call(
            tenantId: tenantId,
            limit: _communityPageSize,
            offset: current.offset,
          );

      if (!ref.mounted) {
        return;
      }

      final merged = [...current.items, ...nextItems];
      state = AsyncData(
        current.copyWith(
          items: merged,
          offset: merged.length,
          hasMore: nextItems.length == _communityPageSize,
          isLoadingMore: false,
          hasLoadMoreError: false,
        ),
      );
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncData(
        current.copyWith(isLoadingMore: false, hasLoadMoreError: true),
      );
    }
  }

  Future<void> retryLoadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.hasLoadMoreError) {
      return;
    }
    state = AsyncData(current.copyWith(hasLoadMoreError: false));
    await loadMore();
  }

  Future<CommunityFeedState> _loadInitial() async {
    final tenantId = ref.read(tenantIdProvider);
    final firstItems = await ref
        .read(getCommunityPostsPageUseCaseProvider)
        .call(tenantId: tenantId, limit: _communityPageSize, offset: 0);

    return CommunityFeedState(
      items: firstItems,
      offset: firstItems.length,
      hasMore: firstItems.length == _communityPageSize,
      isLoadingMore: false,
      hasLoadMoreError: false,
    );
  }
}

final communityFeedControllerProvider =
    AsyncNotifierProvider<CommunityFeedController, CommunityFeedState>(
      CommunityFeedController.new,
    );

final communityPostDetailProvider =
    FutureProvider.family<CommunityPostEntity, String>((ref, postId) async {
      final tenantId = ref.read(tenantIdProvider);
      return ref
          .read(getCommunityPostDetailUseCaseProvider)
          .call(tenantId: tenantId, postId: postId);
    });

final communityCommentsProvider =
    FutureProvider.family<List<CommunityCommentEntity>, String>((
      ref,
      postId,
    ) async {
      final tenantId = ref.read(tenantIdProvider);
      return ref
          .read(getCommunityCommentsUseCaseProvider)
          .call(tenantId: tenantId, postId: postId);
    });

class CommunityActionController extends AsyncNotifier<void> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> createPost({
    required String content,
    required List<String> imageUrls,
  }) async {
    state = const AsyncLoading();
    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(createCommunityPostUseCaseProvider)
          .call(tenantId: tenantId, content: content, imageUrls: imageUrls),
    );
    if (!ref.mounted) {
      return;
    }
    state = nextState;
    if (!state.hasError) {
      ref.invalidate(communityFeedControllerProvider);
    }
  }

  Future<void> updatePost({
    required String postId,
    required String content,
    required List<String> imageUrls,
  }) async {
    state = const AsyncLoading();
    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(updateCommunityPostUseCaseProvider)
          .call(
            tenantId: tenantId,
            postId: postId,
            content: content,
            imageUrls: imageUrls,
          ),
    );
    if (!ref.mounted) {
      return;
    }
    state = nextState;
    if (!state.hasError) {
      ref.invalidate(communityFeedControllerProvider);
      ref.invalidate(communityPostDetailProvider(postId));
    }
  }

  Future<void> deletePost({
    required String postId,
    required List<String> imageUrls,
  }) async {
    state = const AsyncLoading();
    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(deleteCommunityPostUseCaseProvider)
          .call(tenantId: tenantId, postId: postId),
    );
    if (!ref.mounted) {
      return;
    }
    state = nextState;
    if (!state.hasError) {
      for (final imageUrl in imageUrls) {
        try {
          await ref
              .read(storageServiceProvider)
              .removeCommunityMediaByPublicUrl(publicUrl: imageUrl);
        } catch (_) {}
      }
      ref.invalidate(communityFeedControllerProvider);
      ref.invalidate(communityPostDetailProvider(postId));
      ref.invalidate(communityCommentsProvider(postId));
    }
  }

  Future<void> createComment({
    required String postId,
    required String content,
  }) async {
    state = const AsyncLoading();
    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(createCommunityCommentUseCaseProvider)
          .call(tenantId: tenantId, postId: postId, content: content),
    );
    if (!ref.mounted) {
      return;
    }
    state = nextState;
    if (!state.hasError) {
      ref.invalidate(communityFeedControllerProvider);
      ref.invalidate(communityPostDetailProvider(postId));
      ref.invalidate(communityCommentsProvider(postId));
    }
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    state = const AsyncLoading();
    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(deleteCommunityCommentUseCaseProvider)
          .call(tenantId: tenantId, commentId: commentId),
    );
    if (!ref.mounted) {
      return;
    }
    state = nextState;
    if (!state.hasError) {
      ref.invalidate(communityFeedControllerProvider);
      ref.invalidate(communityPostDetailProvider(postId));
      ref.invalidate(communityCommentsProvider(postId));
    }
  }

  Future<void> toggleLike({
    required String postId,
    required bool currentLike,
  }) async {
    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(setCommunityPostLikeUseCaseProvider)
          .call(tenantId: tenantId, postId: postId, like: !currentLike),
    );
    if (!ref.mounted) {
      return;
    }
    state = nextState;
    if (!state.hasError) {
      ref.invalidate(communityFeedControllerProvider);
      ref.invalidate(communityPostDetailProvider(postId));
    }
  }
}

final communityActionControllerProvider =
    AsyncNotifierProvider<CommunityActionController, void>(
      CommunityActionController.new,
    );
