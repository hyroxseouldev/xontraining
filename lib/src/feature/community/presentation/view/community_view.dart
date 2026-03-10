import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';
import 'package:xontraining/src/feature/community/infra/entity/community_entity.dart';
import 'package:xontraining/src/feature/community/presentation/provider/community_provider.dart';
import 'package:xontraining/src/feature/community/presentation/widget/community_post_card.dart';
import 'package:xontraining/src/feature/community/presentation/widget/community_skeleton.dart';
import 'package:xontraining/src/shared/empty_state.dart';
import 'package:xontraining/src/shared/layout_breakpoints.dart';

class CommunityView extends HookConsumerWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final accessState = ref.watch(communityAccessProvider);
    final hasCommunityAccess = accessState.asData?.value ?? false;
    final feedState = hasCommunityAccess
        ? ref.watch(communityFeedControllerProvider)
        : const AsyncData<CommunityFeedState>(
            CommunityFeedState(
              items: <CommunityPostEntity>[],
              offset: 0,
              hasMore: false,
              isLoadingMore: false,
              hasLoadMoreError: false,
            ),
          );
    final actionState = ref.watch(communityActionControllerProvider);
    final currentUserId = ref.watch(authSessionProvider).asData?.value?.id;
    final scrollController = useScrollController();
    final isTablet = LayoutBreakpoints.isTablet(context);

    useEffect(() {
      void listener() {
        if (!scrollController.hasClients) {
          return;
        }
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        final current = ref.read(communityFeedControllerProvider).asData?.value;
        final canLoadMore =
            current != null &&
            hasCommunityAccess &&
            current.hasMore &&
            !current.isLoadingMore &&
            !current.hasLoadMoreError;
        if (canLoadMore && currentScroll >= maxScroll - 300) {
          ref.read(communityFeedControllerProvider.notifier).loadMore();
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController, ref]);

    if (hasCommunityAccess) {
      ref.listen<AsyncValue<CommunityFeedState>>(
        communityFeedControllerProvider,
        (previous, next) {
          next.whenOrNull(
            error: (error, stackTrace) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.communityLoadFailed)));
            },
          );
        },
      );
    }

    ref.listen<AsyncValue<void>>(communityActionControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.communityActionFailed)));
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
                l10n.communityTitle,
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
      floatingActionButton: hasCommunityAccess
          ? FloatingActionButton.extended(
              onPressed: () => context.pushNamed(AppRoutes.communityWriteName),
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.communityWrite),
            )
          : null,
      body: accessState.when(
        loading: () => const CommunityFeedLoadingSkeleton(),
        error: (error, stackTrace) =>
            EmptyState(message: l10n.communityLoadFailed),
        data: (canAccess) {
          if (!canAccess) {
            return EmptyState(
              message: l10n.communityMembershipRequired,
              icon: Icons.lock_outline,
            );
          }

          return feedState.when(
            loading: () => const CommunityFeedLoadingSkeleton(),
            error: (error, stackTrace) =>
                EmptyState(message: l10n.communityLoadFailed),
            data: (feed) {
              if (feed.items.isEmpty) {
                return EmptyState(
                  message: l10n.communityEmpty,
                  icon: Icons.forum_outlined,
                );
              }

              return RefreshIndicator(
                onRefresh: () => ref
                    .read(communityFeedControllerProvider.notifier)
                    .refresh(),
                child: isTablet
                    ? CustomScrollView(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(12, 6, 12, 84),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.84,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final post = feed.items[index];
                                return CommunityPostCard(
                                  post: post,
                                  isMine: currentUserId == post.authorId,
                                  onTap: () {
                                    context.pushNamed(
                                      AppRoutes.communityDetailName,
                                      pathParameters: {'postId': post.id},
                                    );
                                  },
                                  onLikePressed: () {
                                    ref
                                        .read(
                                          communityActionControllerProvider
                                              .notifier,
                                        )
                                        .toggleLike(
                                          postId: post.id,
                                          currentLike: post.isLikedByMe,
                                        );
                                  },
                                  onEditPressed:
                                      !actionState.isLoading &&
                                          currentUserId == post.authorId
                                      ? () {
                                          context.pushNamed(
                                            AppRoutes.communityEditName,
                                            pathParameters: {'postId': post.id},
                                            extra: {
                                              'content': post.normalizedContent,
                                              'images':
                                                  post.normalizedImageUrls,
                                            },
                                          );
                                        }
                                      : null,
                                  onDeletePressed:
                                      !actionState.isLoading &&
                                          currentUserId == post.authorId
                                      ? () async {
                                          final confirmed =
                                              await _showConfirmDialog(
                                                context,
                                                title: l10n
                                                    .communityDeletePostTitle,
                                                body: l10n
                                                    .communityDeletePostBody,
                                                confirmText:
                                                    l10n.communityDelete,
                                              );
                                          if (!context.mounted || !confirmed) {
                                            return;
                                          }
                                          await ref
                                              .read(
                                                communityActionControllerProvider
                                                    .notifier,
                                              )
                                              .deletePost(
                                                postId: post.id,
                                                imageUrls:
                                                    post.normalizedImageUrls,
                                              );
                                        }
                                      : null,
                                  onReportPressed: actionState.isLoading
                                      ? null
                                      : () async {
                                          final report =
                                              await _showReportDialog(context);
                                          if (!context.mounted ||
                                              report == null) {
                                            return;
                                          }
                                          await ref
                                              .read(
                                                communityActionControllerProvider
                                                    .notifier,
                                              )
                                              .reportPost(
                                                postId: post.id,
                                                reason: report.reason,
                                                detail: report.detail,
                                              );
                                          if (!context.mounted) {
                                            return;
                                          }
                                          if (!ref
                                              .read(
                                                communityActionControllerProvider,
                                              )
                                              .hasError) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  l10n.communityReportSubmitted,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  onHidePressed: actionState.isLoading
                                      ? null
                                      : () async {
                                          final confirmed =
                                              await _showConfirmDialog(
                                                context,
                                                title:
                                                    l10n.communityHidePostTitle,
                                                body:
                                                    l10n.communityHidePostBody,
                                                confirmText: l10n.communityHide,
                                              );
                                          if (!context.mounted || !confirmed) {
                                            return;
                                          }
                                          await ref
                                              .read(
                                                communityActionControllerProvider
                                                    .notifier,
                                              )
                                              .hidePost(postId: post.id);
                                          if (!context.mounted) {
                                            return;
                                          }
                                          if (!ref
                                              .read(
                                                communityActionControllerProvider,
                                              )
                                              .hasError) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  l10n.communityPostHidden,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  onBlockUserPressed: actionState.isLoading
                                      ? null
                                      : () async {
                                          final confirmed =
                                              await _showConfirmDialog(
                                                context,
                                                title: l10n
                                                    .communityBlockUserTitle,
                                                body:
                                                    l10n.communityBlockUserBody,
                                                confirmText:
                                                    l10n.communityBlockUser,
                                              );
                                          if (!context.mounted || !confirmed) {
                                            return;
                                          }
                                          await ref
                                              .read(
                                                communityActionControllerProvider
                                                    .notifier,
                                              )
                                              .blockUser(
                                                blockedUserId: post.authorId,
                                              );
                                          if (!context.mounted) {
                                            return;
                                          }
                                          if (!ref
                                              .read(
                                                communityActionControllerProvider,
                                              )
                                              .hasError) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  l10n.communityUserBlocked,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                );
                              }, childCount: feed.items.length),
                            ),
                          ),
                          if (feed.isLoadingMore || feed.hasLoadMoreError)
                            SliverToBoxAdapter(
                              child: _CommunityLoadMoreSection(
                                hasLoadMoreError: feed.hasLoadMoreError,
                                retryText: l10n.communityRetry,
                                onRetry: () {
                                  ref
                                      .read(
                                        communityFeedControllerProvider
                                            .notifier,
                                      )
                                      .retryLoadMore();
                                },
                              ),
                            ),
                        ],
                      )
                    : ListView.separated(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 84),
                        itemCount:
                            feed.items.length +
                            ((feed.isLoadingMore || feed.hasLoadMoreError)
                                ? 1
                                : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 2),
                        itemBuilder: (context, index) {
                          if (index >= feed.items.length) {
                            return _CommunityLoadMoreSection(
                              hasLoadMoreError: feed.hasLoadMoreError,
                              retryText: l10n.communityRetry,
                              onRetry: () {
                                ref
                                    .read(
                                      communityFeedControllerProvider.notifier,
                                    )
                                    .retryLoadMore();
                              },
                            );
                          }

                          final post = feed.items[index];
                          return CommunityPostCard(
                            post: post,
                            isMine: currentUserId == post.authorId,
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.communityDetailName,
                                pathParameters: {'postId': post.id},
                              );
                            },
                            onLikePressed: () {
                              ref
                                  .read(
                                    communityActionControllerProvider.notifier,
                                  )
                                  .toggleLike(
                                    postId: post.id,
                                    currentLike: post.isLikedByMe,
                                  );
                            },
                            onEditPressed:
                                !actionState.isLoading &&
                                    currentUserId == post.authorId
                                ? () {
                                    context.pushNamed(
                                      AppRoutes.communityEditName,
                                      pathParameters: {'postId': post.id},
                                      extra: {
                                        'content': post.normalizedContent,
                                        'images': post.normalizedImageUrls,
                                      },
                                    );
                                  }
                                : null,
                            onDeletePressed:
                                !actionState.isLoading &&
                                    currentUserId == post.authorId
                                ? () async {
                                    final confirmed = await _showConfirmDialog(
                                      context,
                                      title: l10n.communityDeletePostTitle,
                                      body: l10n.communityDeletePostBody,
                                      confirmText: l10n.communityDelete,
                                    );
                                    if (!context.mounted || !confirmed) {
                                      return;
                                    }
                                    await ref
                                        .read(
                                          communityActionControllerProvider
                                              .notifier,
                                        )
                                        .deletePost(
                                          postId: post.id,
                                          imageUrls: post.normalizedImageUrls,
                                        );
                                  }
                                : null,
                            onReportPressed: actionState.isLoading
                                ? null
                                : () async {
                                    final report = await _showReportDialog(
                                      context,
                                    );
                                    if (!context.mounted || report == null) {
                                      return;
                                    }
                                    await ref
                                        .read(
                                          communityActionControllerProvider
                                              .notifier,
                                        )
                                        .reportPost(
                                          postId: post.id,
                                          reason: report.reason,
                                          detail: report.detail,
                                        );
                                    if (!context.mounted) {
                                      return;
                                    }
                                    if (!ref
                                        .read(communityActionControllerProvider)
                                        .hasError) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.communityReportSubmitted,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            onHidePressed: actionState.isLoading
                                ? null
                                : () async {
                                    final confirmed = await _showConfirmDialog(
                                      context,
                                      title: l10n.communityHidePostTitle,
                                      body: l10n.communityHidePostBody,
                                      confirmText: l10n.communityHide,
                                    );
                                    if (!context.mounted || !confirmed) {
                                      return;
                                    }
                                    await ref
                                        .read(
                                          communityActionControllerProvider
                                              .notifier,
                                        )
                                        .hidePost(postId: post.id);
                                    if (!context.mounted) {
                                      return;
                                    }
                                    if (!ref
                                        .read(communityActionControllerProvider)
                                        .hasError) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.communityPostHidden,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            onBlockUserPressed: actionState.isLoading
                                ? null
                                : () async {
                                    final confirmed = await _showConfirmDialog(
                                      context,
                                      title: l10n.communityBlockUserTitle,
                                      body: l10n.communityBlockUserBody,
                                      confirmText: l10n.communityBlockUser,
                                    );
                                    if (!context.mounted || !confirmed) {
                                      return;
                                    }
                                    await ref
                                        .read(
                                          communityActionControllerProvider
                                              .notifier,
                                        )
                                        .blockUser(
                                          blockedUserId: post.authorId,
                                        );
                                    if (!context.mounted) {
                                      return;
                                    }
                                    if (!ref
                                        .read(communityActionControllerProvider)
                                        .hasError) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.communityUserBlocked,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          );
                        },
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CommunityLoadMoreSection extends StatelessWidget {
  const _CommunityLoadMoreSection({
    required this.hasLoadMoreError,
    required this.retryText,
    required this.onRetry,
  });

  final bool hasLoadMoreError;
  final String retryText;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (hasLoadMoreError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(retryText),
          ),
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _CommunityReportDialogResult {
  const _CommunityReportDialogResult({
    required this.reason,
    required this.detail,
  });

  final String reason;
  final String detail;
}

Future<_CommunityReportDialogResult?> _showReportDialog(
  BuildContext context,
) async {
  final l10n = AppLocalizations.of(context)!;
  final detailController = TextEditingController();
  var selectedReason = 'spam';
  return showDialog<_CommunityReportDialogResult>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.communityReportTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedReason,
                  decoration: InputDecoration(
                    labelText: l10n.communityReportReason,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'spam',
                      child: Text(l10n.communityReportReasonSpam),
                    ),
                    DropdownMenuItem(
                      value: 'hate',
                      child: Text(l10n.communityReportReasonHate),
                    ),
                    DropdownMenuItem(
                      value: 'sexual',
                      child: Text(l10n.communityReportReasonSexual),
                    ),
                    DropdownMenuItem(
                      value: 'harassment',
                      child: Text(l10n.communityReportReasonHarassment),
                    ),
                    DropdownMenuItem(
                      value: 'other',
                      child: Text(l10n.communityReportReasonOther),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      selectedReason = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: detailController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: l10n.communityReportDetail,
                    hintText: l10n.communityReportDetailHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.communityCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(
                  _CommunityReportDialogResult(
                    reason: selectedReason,
                    detail: detailController.text.trim(),
                  ),
                ),
                child: Text(l10n.communityReportSubmit),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<bool> _showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmText,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.communityCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
