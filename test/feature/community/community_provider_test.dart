import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/community/data/repository/community_repository.dart';
import 'package:xontraining/src/feature/community/infra/entity/community_entity.dart';
import 'package:xontraining/src/feature/community/infra/usecase/community_usecases.dart';
import 'package:xontraining/src/feature/community/presentation/provider/community_provider.dart';

void main() {
  group('CommunityFeedController', () {
    test('loads initial page and keeps latest-first ordering', () async {
      final repo = _FakeCommunityRepository(
        postPageResponses: [
          [
            _post(id: 'new', createdAt: DateTime(2026, 1, 2, 12)),
            _post(id: 'old', createdAt: DateTime(2026, 1, 1, 12)),
          ],
        ],
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          getCommunityPostsPageUseCaseProvider.overrideWithValue(
            GetCommunityPostsPageUseCase(repository: repo),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(
        communityFeedControllerProvider.future,
      );

      expect(state.items.map((item) => item.id), ['new', 'old']);
      expect(repo.pageRequests.single.offset, 0);
      expect(repo.pageRequests.single.limit, 10);
    });

    test('loadMore appends next page and updates pagination flags', () async {
      final repo = _FakeCommunityRepository(
        postPageResponses: [
          List<CommunityPostEntity>.generate(
            10,
            (index) => _post(id: 'p$index', createdAt: DateTime(2026, 1, 2)),
          ),
          [
            _post(id: 'p10', createdAt: DateTime(2026, 1, 1)),
            _post(id: 'p11', createdAt: DateTime(2026, 1, 1)),
          ],
        ],
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          getCommunityPostsPageUseCaseProvider.overrideWithValue(
            GetCommunityPostsPageUseCase(repository: repo),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(communityFeedControllerProvider.future);
      await container.read(communityFeedControllerProvider.notifier).loadMore();

      final current = container
          .read(communityFeedControllerProvider)
          .asData!
          .value;
      expect(current.items.length, 12);
      expect(current.offset, 12);
      expect(current.hasMore, isFalse);
      expect(repo.pageRequests.map((req) => req.offset), [0, 10]);
    });
  });

  group('CommunityActionController', () {
    test('createPost calls use case and invalidates feed provider', () async {
      final repo = _FakeCommunityRepository(
        postPageResponses: [
          List<CommunityPostEntity>.generate(
            10,
            (index) => _post(id: 'init$index', createdAt: DateTime(2026, 1, 2)),
          ),
          List<CommunityPostEntity>.generate(
            10,
            (index) => _post(id: 'next$index', createdAt: DateTime(2026, 1, 3)),
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          getCommunityPostsPageUseCaseProvider.overrideWithValue(
            GetCommunityPostsPageUseCase(repository: repo),
          ),
          createCommunityPostUseCaseProvider.overrideWithValue(
            CreateCommunityPostUseCase(repository: repo),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(communityFeedControllerProvider.future);
      await container
          .read(communityActionControllerProvider.notifier)
          .createPost(
            content: 'hello',
            imageUrls: const ['https://img.test/1.jpg'],
          );

      await container.read(communityFeedControllerProvider.future);

      expect(repo.createPostCalls, 1);
      expect(repo.lastCreateContent, 'hello');
      expect(repo.lastCreateImageUrls, ['https://img.test/1.jpg']);
      expect(repo.pageRequests.length, 2);
      expect(repo.pageRequests[0].offset, 0);
      expect(repo.pageRequests[1].offset, 0);
    });
  });
}

CommunityPostEntity _post({required String id, required DateTime createdAt}) {
  return CommunityPostEntity(
    id: id,
    authorId: 'author-$id',
    authorName: 'Author $id',
    authorAvatarUrl: '',
    authorRole: '',
    content: 'content $id',
    imageUrls: const [],
    createdAt: createdAt,
    updatedAt: createdAt,
    likeCount: 0,
    commentCount: 0,
    isLikedByMe: false,
  );
}

class _PageRequest {
  const _PageRequest({required this.limit, required this.offset});

  final int limit;
  final int offset;
}

class _FakeCommunityRepository implements CommunityRepository {
  _FakeCommunityRepository({required this.postPageResponses});

  final List<List<CommunityPostEntity>> postPageResponses;
  final List<_PageRequest> pageRequests = <_PageRequest>[];

  int _postPageIndex = 0;
  int createPostCalls = 0;
  String? lastCreateContent;
  List<String>? lastCreateImageUrls;

  @override
  Future<bool> hasCommunityAccess({
    required String tenantId,
    required String userId,
  }) async {
    return true;
  }

  @override
  Future<List<CommunityPostEntity>> getPostsPage({
    required String tenantId,
    required int limit,
    required int offset,
  }) async {
    pageRequests.add(_PageRequest(limit: limit, offset: offset));
    if (_postPageIndex >= postPageResponses.length) {
      return const <CommunityPostEntity>[];
    }
    final result = postPageResponses[_postPageIndex];
    _postPageIndex += 1;
    return result;
  }

  @override
  Future<void> createPost({
    required String tenantId,
    required String content,
    required List<String> imageUrls,
  }) async {
    createPostCalls += 1;
    lastCreateContent = content;
    lastCreateImageUrls = imageUrls;
  }

  @override
  Future<void> blockUser({
    required String tenantId,
    required String blockedUserId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> createComment({
    required String tenantId,
    required String postId,
    required String content,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteComment({
    required String tenantId,
    required String commentId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost({required String tenantId, required String postId}) {
    throw UnimplementedError();
  }

  @override
  Future<List<CommunityCommentEntity>> getComments({
    required String tenantId,
    required String postId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<CommunityPostEntity> getPostDetail({
    required String tenantId,
    required String postId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> hidePost({required String tenantId, required String postId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> reportComment({
    required String tenantId,
    required String commentId,
    required String reason,
    required String detail,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> reportPost({
    required String tenantId,
    required String postId,
    required String reason,
    required String detail,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> setPostLiked({
    required String tenantId,
    required String postId,
    required bool like,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> updatePost({
    required String tenantId,
    required String postId,
    required String content,
    required List<String> imageUrls,
  }) {
    throw UnimplementedError();
  }
}
