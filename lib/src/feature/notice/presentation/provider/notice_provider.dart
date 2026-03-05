import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/notice/infra/entity/notice_entity.dart';
import 'package:xontraining/src/feature/notice/infra/usecase/notice_usecases.dart';

part 'notice_provider.g.dart';

const _noticePageSize = 10;

class NoticeFeedState {
  const NoticeFeedState({
    required this.items,
    required this.isLoadingMore,
    required this.hasLoadMoreError,
    required this.hasMore,
    required this.offset,
  });

  final List<NoticeEntity> items;
  final bool isLoadingMore;
  final bool hasLoadMoreError;
  final bool hasMore;
  final int offset;

  NoticeFeedState copyWith({
    List<NoticeEntity>? items,
    bool? isLoadingMore,
    bool? hasLoadMoreError,
    bool? hasMore,
    int? offset,
  }) {
    return NoticeFeedState(
      items: items ?? this.items,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasLoadMoreError: hasLoadMoreError ?? this.hasLoadMoreError,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
    );
  }
}

@riverpod
class NoticeFeedController extends _$NoticeFeedController {
  @override
  Future<NoticeFeedState> build() async {
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
          .read(getNoticesPageUseCaseProvider)
          .call(
            tenantId: tenantId,
            limit: _noticePageSize,
            offset: current.offset,
          );

      if (!ref.mounted) {
        return;
      }

      final merged = [...current.items, ...nextItems];
      state = AsyncData(
        current.copyWith(
          items: merged,
          isLoadingMore: false,
          hasLoadMoreError: false,
          hasMore: nextItems.length == _noticePageSize,
          offset: merged.length,
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

  Future<NoticeFeedState> _loadInitial() async {
    final tenantId = ref.read(tenantIdProvider);
    final firstItems = await ref
        .read(getNoticesPageUseCaseProvider)
        .call(tenantId: tenantId, limit: _noticePageSize, offset: 0);

    return NoticeFeedState(
      items: firstItems,
      isLoadingMore: false,
      hasLoadMoreError: false,
      hasMore: firstItems.length == _noticePageSize,
      offset: firstItems.length,
    );
  }
}

@riverpod
Future<NoticeEntity> noticeDetail(Ref ref, {required String noticeId}) async {
  final tenantId = ref.read(tenantIdProvider);
  return ref
      .read(getNoticeByIdUseCaseProvider)
      .call(tenantId: tenantId, noticeId: noticeId);
}
