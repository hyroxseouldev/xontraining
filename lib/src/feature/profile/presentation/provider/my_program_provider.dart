import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';
import 'package:xontraining/src/feature/profile/infra/entity/my_program_entity.dart';
import 'package:xontraining/src/feature/profile/infra/usecase/my_program_usecases.dart';

const _myProgramsPageSize = 10;

final myProgramUserIdProvider = FutureProvider<String?>((ref) async {
  final user = await ref.read(authSessionProvider.future);
  return user?.id;
});

class MyProgramFeedState {
  const MyProgramFeedState({
    required this.items,
    required this.totalCount,
    required this.offset,
    required this.hasMore,
    required this.isLoadingMore,
    required this.hasLoadMoreError,
  });

  final List<MyProgramItemEntity> items;
  final int totalCount;
  final int offset;
  final bool hasMore;
  final bool isLoadingMore;
  final bool hasLoadMoreError;

  MyProgramFeedState copyWith({
    List<MyProgramItemEntity>? items,
    int? totalCount,
    int? offset,
    bool? hasMore,
    bool? isLoadingMore,
    bool? hasLoadMoreError,
  }) {
    return MyProgramFeedState(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasLoadMoreError: hasLoadMoreError ?? this.hasLoadMoreError,
    );
  }
}

abstract class _BaseMyProgramFeedController
    extends AsyncNotifier<MyProgramFeedState> {
  MyProgramStatus get status;

  @override
  Future<MyProgramFeedState> build() async {
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
      final nextPage = await _loadPage(offset: current.offset);
      if (!ref.mounted) {
        return;
      }

      final merged = [...current.items, ...nextPage.items];
      state = AsyncData(
        current.copyWith(
          items: merged,
          totalCount: nextPage.totalCount,
          offset: nextPage.nextOffset,
          hasMore: nextPage.hasMore,
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

  Future<MyProgramFeedState> _loadInitial() async {
    final firstPage = await _loadPage(offset: 0);
    return MyProgramFeedState(
      items: firstPage.items,
      totalCount: firstPage.totalCount,
      offset: firstPage.nextOffset,
      hasMore: firstPage.hasMore,
      isLoadingMore: false,
      hasLoadMoreError: false,
    );
  }

  Future<MyProgramPageEntity> _loadPage({required int offset}) async {
    final tenantId = ref.read(tenantIdProvider);
    final userId = await ref.read(myProgramUserIdProvider.future);
    if (userId == null) {
      return const MyProgramPageEntity(
        items: [],
        totalCount: 0,
        nextOffset: 0,
        hasMore: false,
      );
    }

    return ref
        .read(getMyProgramsPageUseCaseProvider)
        .call(
          tenantId: tenantId,
          userId: userId,
          status: status,
          limit: _myProgramsPageSize,
          offset: offset,
        );
  }
}

class ActiveMyProgramFeedController extends _BaseMyProgramFeedController {
  @override
  MyProgramStatus get status => MyProgramStatus.active;
}

class InactiveMyProgramFeedController extends _BaseMyProgramFeedController {
  @override
  MyProgramStatus get status => MyProgramStatus.inactive;
}

final activeMyProgramFeedControllerProvider =
    AsyncNotifierProvider<ActiveMyProgramFeedController, MyProgramFeedState>(
      ActiveMyProgramFeedController.new,
    );

final inactiveMyProgramFeedControllerProvider =
    AsyncNotifierProvider<InactiveMyProgramFeedController, MyProgramFeedState>(
      InactiveMyProgramFeedController.new,
    );
