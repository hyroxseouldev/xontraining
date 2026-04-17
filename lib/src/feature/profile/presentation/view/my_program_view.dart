import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/profile/infra/entity/my_program_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/my_program_provider.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class MyProgramView extends StatelessWidget {
  const MyProgramView({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(length: 2, child: _MyProgramViewBody());
  }
}

class _MyProgramViewBody extends HookConsumerWidget {
  const _MyProgramViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final activeState = ref.watch(activeMyProgramFeedControllerProvider);
    final inactiveState = ref.watch(inactiveMyProgramFeedControllerProvider);

    void showLoadFailed() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileMyProgramsLoadFailed)));
    }

    ref.listen<AsyncValue<MyProgramFeedState>>(
      activeMyProgramFeedControllerProvider,
      (previous, next) {
        if (next.hasError && !next.isLoading) {
          showLoadFailed();
        }
      },
    );
    ref.listen<AsyncValue<MyProgramFeedState>>(
      inactiveMyProgramFeedControllerProvider,
      (previous, next) {
        if (next.hasError && !next.isLoading) {
          showLoadFailed();
        }
      },
    );

    final tabController = DefaultTabController.of(context);
    useListenable(tabController);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    l10n.profileMyPrograms,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
              TabBar(
                tabs: [
                  Tab(
                    child: _ProgramTabLabel(
                      title: l10n.profileMyProgramsActive,
                      count: activeState.asData?.value.totalCount ?? 0,
                      isSelected: tabController.index == 0,
                    ),
                  ),
                  Tab(
                    child: _ProgramTabLabel(
                      title: l10n.profileMyProgramsInactive,
                      count: inactiveState.asData?.value.totalCount ?? 0,
                      isSelected: tabController.index == 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        children: [
          _MyProgramTabContent(
            state: activeState,
            onRefresh: _refreshActivePrograms,
            onLoadMore: _loadMoreActivePrograms,
            onRetryLoadMore: _retryLoadMoreActivePrograms,
            emptyIcon: Icons.play_circle_outline,
            isActiveTab: true,
          ),
          _MyProgramTabContent(
            state: inactiveState,
            onRefresh: _refreshInactivePrograms,
            onLoadMore: _loadMoreInactivePrograms,
            onRetryLoadMore: _retryLoadMoreInactivePrograms,
            emptyIcon: Icons.pause_circle_outline,
            isActiveTab: false,
          ),
        ],
      ),
    );
  }
}

class _MyProgramTabContent extends HookConsumerWidget {
  const _MyProgramTabContent({
    required this.state,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetryLoadMore,
    required this.emptyIcon,
    required this.isActiveTab,
  });

  final AsyncValue<MyProgramFeedState> state;
  final Future<void> Function(WidgetRef ref) onRefresh;
  final Future<void> Function(WidgetRef ref) onLoadMore;
  final Future<void> Function(WidgetRef ref) onRetryLoadMore;
  final IconData emptyIcon;
  final bool isActiveTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scrollController = useScrollController();

    useEffect(() {
      void listener() {
        if (!scrollController.hasClients) {
          return;
        }
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        final feedState = state.asData?.value;
        final canLoadMore =
            feedState != null &&
            feedState.hasMore &&
            !feedState.isLoadingMore &&
            !feedState.hasLoadMoreError;

        if (canLoadMore && currentScroll >= maxScroll - 300) {
          onLoadMore(ref);
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController, ref, state]);

    final emptyMessage = isActiveTab
        ? l10n.profileMyProgramsEmptyActive
        : l10n.profileMyProgramsEmptyInactive;

    return state.when(
      loading: () => const _MyProgramLoadingSkeleton(),
      error: (error, stackTrace) => _MyProgramErrorState(onRefresh: onRefresh),
      data: (feed) {
        if (feed.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => onRefresh(ref),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.55,
                  child: EmptyState(message: emptyMessage, icon: emptyIcon),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => onRefresh(ref),
          child: ListView.separated(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount:
                feed.items.length +
                ((feed.isLoadingMore || feed.hasLoadMoreError) ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index >= feed.items.length) {
                return _MyProgramLoadMoreSection(
                  hasLoadMoreError: feed.hasLoadMoreError,
                  loadMoreFailedText: l10n.profileMyProgramsLoadMoreFailed,
                  retryText: l10n.profileMyProgramsRetry,
                  onRetry: () => onRetryLoadMore(ref),
                );
              }

              final item = feed.items[index];
              return _MyProgramCard(
                item: item,
                isActiveTab: isActiveTab,
                onTap: () => _openProgramDetail(context, item.program),
              );
            },
          ),
        );
      },
    );
  }
}

void _openProgramDetail(BuildContext context, ProgramEntity program) {
  context.pushNamed(
    AppRoutes.programDetailName,
    pathParameters: {'programId': program.id},
    extra: program,
  );
}

class _ProgramTabLabel extends StatelessWidget {
  const _ProgramTabLabel({
    required this.title,
    required this.count,
    required this.isSelected,
  });

  final String title;
  final int count;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.12)
                : colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _MyProgramCard extends StatelessWidget {
  const _MyProgramCard({
    required this.item,
    required this.isActiveTab,
    this.onTap,
  });

  final MyProgramItemEntity item;
  final bool isActiveTab;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final program = item.program;
    final colorScheme = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    final mutedStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final dateFormatter = DateFormat('yyyy.MM.dd', locale.languageCode);
    final status = _statusPresentation(
      l10n: l10n,
      item: item,
      colorScheme: colorScheme,
      isActiveTab: isActiveTab,
    );
    final activationPeriod = _activationPeriodText(
      l10n: l10n,
      formatter: dateFormatter,
      item: item,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProgramThumbnail(url: program.normalizedThumbnailUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(program.title, style: titleStyle)),
                        if (status case _StatusBadgeData()) ...[
                          const SizedBox(width: 8),
                          _StatusBadge(data: status),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.profileMyProgramsActivationPeriod,
                      style: mutedStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(activationPeriod, style: bodyStyle),
                    if (status case _StatusTextData()) ...[
                      const SizedBox(height: 6),
                      Text(status.label, style: mutedStyle),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadgeData {
  const _StatusBadgeData({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;
}

class _StatusTextData {
  const _StatusTextData({required this.label});

  final String label;
}

class _ProgramThumbnail extends StatelessWidget {
  const _ProgramThumbnail({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.image_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );

    if (url.isEmpty) {
      return fallback;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 72,
        height: 72,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, imageUrl) => fallback,
          errorWidget: (context, imageUrl, error) => fallback,
        ),
      ),
    );
  }
}

String _activationPeriodText({
  required AppLocalizations l10n,
  required DateFormat formatter,
  required MyProgramItemEntity item,
}) {
  final start = item.activationStartAt;
  final end = item.activationEndAt;
  final startText = start == null
      ? l10n.profileMyProgramsNoStartDate
      : formatter.format(start);
  final endText = end == null
      ? l10n.profileMyProgramsOpenEnded
      : formatter.format(end);
  return '$startText - $endText';
}

Object? _statusPresentation({
  required AppLocalizations l10n,
  required MyProgramItemEntity item,
  required ColorScheme colorScheme,
  required bool isActiveTab,
}) {
  final end = item.activationEndAt;
  if (end == null) {
    return const _StatusBadgeData(
      label: 'ongoing',
      background: Color(0xFFD9FBE8),
      foreground: Color(0xFF0F6B46),
    );
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final endDay = DateTime(end.year, end.month, end.day);
  final diff = endDay.difference(today).inDays;

  if (diff < 0) {
    return _StatusTextData(label: l10n.profileMyProgramsExpired);
  }
  if (diff == 0) {
    return const _StatusBadgeData(
      label: 'today',
      background: Color(0xFFFFDAD6),
      foreground: Color(0xFFBA1A1A),
    );
  }
  if (diff <= 3) {
    return _StatusBadgeData(
      label: l10n.profileMyProgramsDday(diff),
      background: const Color(0xFFFFDAD6),
      foreground: const Color(0xFFBA1A1A),
    );
  }
  if (diff <= 7) {
    return _StatusBadgeData(
      label: l10n.profileMyProgramsDday(diff),
      background: const Color(0xFFFFE7C2),
      foreground: const Color(0xFF9A5800),
    );
  }
  return _StatusBadgeData(
    label: l10n.profileMyProgramsDday(diff),
    background: isActiveTab
        ? colorScheme.primary.withValues(alpha: 0.12)
        : colorScheme.surfaceContainerHigh,
    foreground: isActiveTab
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant,
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.data});

  final _StatusBadgeData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = switch (data.label) {
      'ongoing' => l10n.profileMyProgramsOpenEnded,
      'expired' => l10n.profileMyProgramsExpired,
      'today' => l10n.profileMyProgramsEndsToday,
      _ => data.label,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: data.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: data.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MyProgramErrorState extends ConsumerWidget {
  const _MyProgramErrorState({required this.onRefresh});

  final Future<void> Function(WidgetRef ref) onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.profileMyProgramsLoadFailed,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => onRefresh(ref),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.profileMyProgramsRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyProgramLoadMoreSection extends StatelessWidget {
  const _MyProgramLoadMoreSection({
    required this.hasLoadMoreError,
    required this.loadMoreFailedText,
    required this.retryText,
    required this.onRetry,
  });

  final bool hasLoadMoreError;
  final String loadMoreFailedText;
  final String retryText;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (hasLoadMoreError) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          children: [
            Text(
              loadMoreFailedText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryText),
            ),
          ],
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

Future<void> _refreshActivePrograms(WidgetRef ref) {
  return ref.read(activeMyProgramFeedControllerProvider.notifier).refresh();
}

Future<void> _loadMoreActivePrograms(WidgetRef ref) {
  return ref.read(activeMyProgramFeedControllerProvider.notifier).loadMore();
}

Future<void> _retryLoadMoreActivePrograms(WidgetRef ref) {
  return ref
      .read(activeMyProgramFeedControllerProvider.notifier)
      .retryLoadMore();
}

Future<void> _refreshInactivePrograms(WidgetRef ref) {
  return ref.read(inactiveMyProgramFeedControllerProvider.notifier).refresh();
}

Future<void> _loadMoreInactivePrograms(WidgetRef ref) {
  return ref.read(inactiveMyProgramFeedControllerProvider.notifier).loadMore();
}

Future<void> _retryLoadMoreInactivePrograms(WidgetRef ref) {
  return ref
      .read(inactiveMyProgramFeedControllerProvider.notifier)
      .retryLoadMore();
}

class _MyProgramLoadingSkeleton extends StatelessWidget {
  const _MyProgramLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => const _MyProgramSkeletonCard(),
    );
  }
}

class _MyProgramSkeletonCard extends StatelessWidget {
  const _MyProgramSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ColoredBox(color: colorScheme.surfaceContainerHighest),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonLine(width: 180),
              const SizedBox(height: 12),
              const _SkeletonInfoRow(),
              const SizedBox(height: 8),
              const _SkeletonInfoRow(),
              const SizedBox(height: 8),
              const _SkeletonInfoRow(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonInfoRow extends StatelessWidget {
  const _SkeletonInfoRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _SkeletonLine()),
        SizedBox(width: 12),
        _SkeletonLine(width: 88),
      ],
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 14,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
