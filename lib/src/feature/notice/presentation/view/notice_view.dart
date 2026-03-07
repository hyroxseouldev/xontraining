import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/notice/presentation/provider/notice_provider.dart';
import 'package:xontraining/src/feature/notice/presentation/widget/notice_list_item.dart';
import 'package:xontraining/src/shared/empty_state.dart';
import 'package:xontraining/src/shared/layout_breakpoints.dart';

class NoticeView extends HookConsumerWidget {
  const NoticeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final noticesState = ref.watch(noticeFeedControllerProvider);
    final scrollController = useScrollController();
    final isTablet = LayoutBreakpoints.isTablet(context);

    useEffect(() {
      void listener() {
        if (!scrollController.hasClients) {
          return;
        }
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        final feedState = ref.read(noticeFeedControllerProvider).asData?.value;
        final canLoadMore =
            feedState != null &&
            feedState.hasMore &&
            !feedState.isLoadingMore &&
            !feedState.hasLoadMoreError;
        if (canLoadMore && currentScroll >= maxScroll - 300) {
          ref.read(noticeFeedControllerProvider.notifier).loadMore();
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController, ref]);

    ref.listen<AsyncValue<NoticeFeedState>>(noticeFeedControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.noticeLoadFailed)));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                l10n.noticeTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ),
      ),
      body: noticesState.when(
        loading: () => _NoticeLoadingSkeleton(isTablet: isTablet),
        error: (error, stackTrace) =>
            EmptyState(message: l10n.noticeLoadFailed),
        data: (items) {
          if (items.items.isEmpty) {
            return EmptyState(
              message: l10n.noticeEmpty,
              icon: Icons.notifications_off_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(noticeFeedControllerProvider.notifier).refresh();
            },
            child: isTablet
                ? CustomScrollView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.82,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final notice = items.items[index];
                            return NoticeListItem(
                              notice: notice,
                              onTap: () {
                                context.pushNamed(
                                  AppRoutes.noticeDetailName,
                                  pathParameters: {'noticeId': notice.id},
                                  extra: notice,
                                );
                              },
                            );
                          }, childCount: items.items.length),
                        ),
                      ),
                      if (items.isLoadingMore || items.hasLoadMoreError)
                        SliverToBoxAdapter(
                          child: _NoticeLoadMoreSection(
                            hasLoadMoreError: items.hasLoadMoreError,
                            loadMoreFailedText: l10n.noticeLoadMoreFailed,
                            retryText: l10n.noticeRetry,
                            onRetry: () {
                              ref
                                  .read(noticeFeedControllerProvider.notifier)
                                  .retryLoadMore();
                            },
                          ),
                        ),
                    ],
                  )
                : ListView.separated(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount:
                        items.items.length +
                        ((items.isLoadingMore || items.hasLoadMoreError)
                            ? 1
                            : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      if (index >= items.items.length) {
                        return _NoticeLoadMoreSection(
                          hasLoadMoreError: items.hasLoadMoreError,
                          loadMoreFailedText: l10n.noticeLoadMoreFailed,
                          retryText: l10n.noticeRetry,
                          onRetry: () {
                            ref
                                .read(noticeFeedControllerProvider.notifier)
                                .retryLoadMore();
                          },
                        );
                      }

                      final notice = items.items[index];
                      return NoticeListItem(
                        notice: notice,
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.noticeDetailName,
                            pathParameters: {'noticeId': notice.id},
                            extra: notice,
                          );
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

class _NoticeLoadingSkeleton extends StatelessWidget {
  const _NoticeLoadingSkeleton({required this.isTablet});

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    if (!isTablet) {
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => const _NoticeListItemSkeleton(),
      );
    }

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => const _NoticeListItemSkeleton(),
    );
  }
}

class _NoticeLoadMoreSection extends StatelessWidget {
  const _NoticeLoadMoreSection({
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

class _NoticeListItemSkeleton extends StatelessWidget {
  const _NoticeListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: AspectRatio(aspectRatio: 1, child: _ShimmerBox()),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(height: 22, width: 180),
              SizedBox(height: 10),
              _ShimmerBox(height: 14, width: 160),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({this.height, this.width});

  final double? height;
  final double? width;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlightColor = Theme.of(context).colorScheme.surfaceContainer;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final shimmerX = (width * 2 * _controller.value) - width;

              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(color: baseColor),
                    Transform.translate(
                      offset: Offset(shimmerX, 0),
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              baseColor.withValues(alpha: 0),
                              highlightColor.withValues(alpha: 0.9),
                              baseColor.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
