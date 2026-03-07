import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/notice/data/repository/notice_repository.dart';
import 'package:xontraining/src/feature/notice/infra/entity/notice_entity.dart';
import 'package:xontraining/src/feature/notice/infra/usecase/notice_usecases.dart';
import 'package:xontraining/src/feature/notice/presentation/provider/notice_provider.dart';

void main() {
  group('NoticeFeedController', () {
    test('loads latest notices first', () async {
      final repo = _FakeNoticeRepository(
        pageResponses: [
          [
            _notice(id: 'new', createdAt: DateTime(2026, 2, 10)),
            _notice(id: 'old', createdAt: DateTime(2026, 1, 1)),
          ],
        ],
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          getNoticesPageUseCaseProvider.overrideWithValue(
            GetNoticesPageUseCase(repository: repo),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(noticeFeedControllerProvider.future);

      expect(state.items.map((item) => item.id), ['new', 'old']);
      expect(repo.pageRequests.single.offset, 0);
      expect(repo.pageRequests.single.limit, 10);
    });

    test('loadMore appends next page and updates hasMore', () async {
      final repo = _FakeNoticeRepository(
        pageResponses: [
          List<NoticeEntity>.generate(
            10,
            (index) => _notice(id: 'n$index', createdAt: DateTime(2026, 2, 1)),
          ),
          [
            _notice(id: 'n10', createdAt: DateTime(2026, 1, 31)),
            _notice(id: 'n11', createdAt: DateTime(2026, 1, 31)),
          ],
        ],
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          getNoticesPageUseCaseProvider.overrideWithValue(
            GetNoticesPageUseCase(repository: repo),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(noticeFeedControllerProvider.future);
      await container.read(noticeFeedControllerProvider.notifier).loadMore();

      final current = container
          .read(noticeFeedControllerProvider)
          .asData!
          .value;
      expect(current.items.length, 12);
      expect(current.offset, 12);
      expect(current.hasMore, isFalse);
      expect(repo.pageRequests.map((req) => req.offset), [0, 10]);
    });

    test('retryLoadMore retries after loadMore failure', () async {
      final repo = _FakeNoticeRepository(
        pageResponses: [
          List<NoticeEntity>.generate(
            10,
            (index) => _notice(id: 'p$index', createdAt: DateTime(2026, 2, 1)),
          ),
          StateError('load more failed'),
          [_notice(id: 'p10', createdAt: DateTime(2026, 1, 31))],
        ],
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          getNoticesPageUseCaseProvider.overrideWithValue(
            GetNoticesPageUseCase(repository: repo),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(noticeFeedControllerProvider.future);
      await container.read(noticeFeedControllerProvider.notifier).loadMore();

      final failed = container.read(noticeFeedControllerProvider).asData!.value;
      expect(failed.hasLoadMoreError, isTrue);

      await container
          .read(noticeFeedControllerProvider.notifier)
          .retryLoadMore();

      final recovered = container
          .read(noticeFeedControllerProvider)
          .asData!
          .value;
      expect(recovered.hasLoadMoreError, isFalse);
      expect(recovered.items.length, 11);
      expect(repo.pageRequests.length, 3);
    });
  });
}

NoticeEntity _notice({required String id, required DateTime createdAt}) {
  return NoticeEntity(
    id: id,
    title: 'title $id',
    contentHtml: '<p>content $id</p>',
    thumbnailUrl: '',
    createdAt: createdAt,
  );
}

class _PageRequest {
  const _PageRequest({required this.limit, required this.offset});

  final int limit;
  final int offset;
}

class _FakeNoticeRepository implements NoticeRepository {
  _FakeNoticeRepository({required this.pageResponses});

  final List<Object> pageResponses;
  final List<_PageRequest> pageRequests = <_PageRequest>[];
  int _index = 0;

  @override
  Future<List<NoticeEntity>> getNoticesPage({
    required String tenantId,
    required int limit,
    required int offset,
  }) async {
    pageRequests.add(_PageRequest(limit: limit, offset: offset));
    final response = pageResponses[_index];
    _index += 1;

    if (response is Exception) {
      throw response;
    }
    if (response is Error) {
      throw response;
    }

    return response as List<NoticeEntity>;
  }

  @override
  Future<NoticeEntity> getNoticeById({
    required String tenantId,
    required String noticeId,
  }) {
    throw UnimplementedError();
  }
}
