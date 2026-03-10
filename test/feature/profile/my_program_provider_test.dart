import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/profile/data/repository/my_program_repository.dart';
import 'package:xontraining/src/feature/profile/infra/entity/my_program_entity.dart';
import 'package:xontraining/src/feature/profile/infra/usecase/my_program_usecases.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/my_program_provider.dart';

void main() {
  group('My program feed controllers', () {
    test('active feed loads count and single active item', () async {
      final repository = _FakeMyProgramRepository(
        activeItems: [_item(id: 'active-1')],
        inactiveItems: List<MyProgramItemEntity>.generate(
          3,
          (index) => _item(id: 'inactive-$index'),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          myProgramUserIdProvider.overrideWith((ref) async => 'user-test'),
          getMyProgramsPageUseCaseProvider.overrideWithValue(
            GetMyProgramsPageUseCase(repository: repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      final state = await container.read(
        activeMyProgramFeedControllerProvider.future,
      );

      expect(state.items.map((item) => item.program.id), ['active-1']);
      expect(state.items.single.activationStartAt, DateTime(2026, 3, 1));
      expect(state.items.single.activationEndAt, DateTime(2026, 3, 31));
      expect(state.totalCount, 1);
      expect(state.hasMore, isFalse);
      expect(repository.requests.single.status, MyProgramStatus.active);
    });

    test('inactive feed loads more with next offset', () async {
      final repository = _FakeMyProgramRepository(
        activeItems: [_item(id: 'active-1')],
        inactiveItems: List<MyProgramItemEntity>.generate(
          12,
          (index) => _item(id: 'inactive-$index'),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          myProgramUserIdProvider.overrideWith((ref) async => 'user-test'),
          getMyProgramsPageUseCaseProvider.overrideWithValue(
            GetMyProgramsPageUseCase(repository: repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(inactiveMyProgramFeedControllerProvider.future);
      await container
          .read(inactiveMyProgramFeedControllerProvider.notifier)
          .loadMore();

      final state = container
          .read(inactiveMyProgramFeedControllerProvider)
          .asData!
          .value;

      expect(state.items.length, 12);
      expect(state.offset, 12);
      expect(state.hasMore, isFalse);
      expect(
        repository.requests
            .where((request) => request.status == MyProgramStatus.inactive)
            .map((request) => request.offset),
        [0, 10],
      );
    });

    test('inactive feed retryLoadMore recovers after failure', () async {
      final repository = _FakeMyProgramRepository(
        activeItems: const [],
        inactiveItems: List<MyProgramItemEntity>.generate(
          11,
          (index) => _item(id: 'inactive-$index'),
        ),
        failOffsets: {10},
      );

      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWithValue('tenant-test'),
          myProgramUserIdProvider.overrideWith((ref) async => 'user-test'),
          getMyProgramsPageUseCaseProvider.overrideWithValue(
            GetMyProgramsPageUseCase(repository: repository),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(inactiveMyProgramFeedControllerProvider.future);
      await container
          .read(inactiveMyProgramFeedControllerProvider.notifier)
          .loadMore();

      final failed = container
          .read(inactiveMyProgramFeedControllerProvider)
          .asData!
          .value;
      expect(failed.hasLoadMoreError, isTrue);

      repository.failOffsets.clear();

      await container
          .read(inactiveMyProgramFeedControllerProvider.notifier)
          .retryLoadMore();

      final recovered = container
          .read(inactiveMyProgramFeedControllerProvider)
          .asData!
          .value;
      expect(recovered.hasLoadMoreError, isFalse);
      expect(recovered.items.length, 11);
    });
  });
}

MyProgramItemEntity _item({required String id}) {
  return MyProgramItemEntity(
    program: ProgramEntity(
      id: id,
      title: 'Program $id',
      description: 'Description $id',
      thumbnailUrl: '',
      difficulty: 'beginner',
      dailyWorkoutMinutes: 40,
      daysPerWeek: 3,
      startDate: DateTime(2026, 3, 1),
      endDate: DateTime(2026, 3, 28),
    ),
    activationStartAt: DateTime(2026, 3, 1),
    activationEndAt: DateTime(2026, 3, 31),
  );
}

class _MyProgramRequest {
  const _MyProgramRequest({
    required this.status,
    required this.limit,
    required this.offset,
  });

  final MyProgramStatus status;
  final int limit;
  final int offset;
}

class _FakeMyProgramRepository implements MyProgramRepository {
  _FakeMyProgramRepository({
    required this.activeItems,
    required this.inactiveItems,
    Set<int>? failOffsets,
  }) : failOffsets = failOffsets ?? <int>{};

  final List<MyProgramItemEntity> activeItems;
  final List<MyProgramItemEntity> inactiveItems;
  final Set<int> failOffsets;
  final List<_MyProgramRequest> requests = <_MyProgramRequest>[];

  @override
  Future<MyProgramPageEntity> getMyProgramsPage({
    required String tenantId,
    required String userId,
    required MyProgramStatus status,
    required int limit,
    required int offset,
  }) async {
    requests.add(
      _MyProgramRequest(status: status, limit: limit, offset: offset),
    );

    if (failOffsets.contains(offset)) {
      throw StateError('load failed');
    }

    final source = status == MyProgramStatus.active
        ? activeItems
        : inactiveItems;
    final items = source.skip(offset).take(limit).toList(growable: false);
    final nextOffset = offset + items.length;

    return MyProgramPageEntity(
      items: items,
      totalCount: source.length,
      nextOffset: nextOffset,
      hasMore: nextOffset < source.length,
    );
  }
}
