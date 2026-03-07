import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';
import 'package:xontraining/src/feature/community/infra/entity/community_entity.dart';
import 'package:xontraining/src/feature/community/presentation/provider/community_provider.dart';
import 'package:xontraining/src/feature/community/presentation/view/community_view_helper.dart';
import 'package:xontraining/src/feature/community/presentation/widget/community_image_viewer.dart';
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
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.78,
                                  ),
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final post = feed.items[index];
                                return _CommunityPostCard(
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
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                        itemCount:
                            feed.items.length +
                            ((feed.isLoadingMore || feed.hasLoadMoreError)
                                ? 1
                                : 0),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
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
                          return _CommunityPostCard(
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

class _CommunityPostCard extends StatelessWidget {
  const _CommunityPostCard({
    required this.post,
    required this.isMine,
    required this.onTap,
    required this.onLikePressed,
    this.onReportPressed,
    this.onHidePressed,
    this.onBlockUserPressed,
  });

  final CommunityPostEntity post;
  final bool isMine;
  final VoidCallback onTap;
  final VoidCallback onLikePressed;
  final VoidCallback? onReportPressed;
  final VoidCallback? onHidePressed;
  final VoidCallback? onBlockUserPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateTimeLabel = buildCommunityPostDateTimeLabel(
      post: post,
      now: DateTime.now(),
      l10n: l10n,
    );
    final previewText = communityHtmlToPlainText(post.normalizedContent);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _CommunityAvatar(
                      imageUrl: post.normalizedAuthorAvatarUrl,
                      radius: 16,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  post.normalizedAuthorName,
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (post.hasCoachBadge) ...[
                                const SizedBox(width: 6),
                                _CommunityCoachBadge(
                                  label: l10n.communityCoachBadge,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dateTimeLabel,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (!isMine)
                      PopupMenuButton<_CommunityPostMenuAction>(
                        onSelected: (value) {
                          switch (value) {
                            case _CommunityPostMenuAction.report:
                              onReportPressed?.call();
                              return;
                            case _CommunityPostMenuAction.hide:
                              onHidePressed?.call();
                              return;
                            case _CommunityPostMenuAction.block:
                              onBlockUserPressed?.call();
                              return;
                          }
                        },
                        itemBuilder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return [
                            PopupMenuItem<_CommunityPostMenuAction>(
                              value: _CommunityPostMenuAction.report,
                              child: Text(l10n.communityReport),
                            ),
                            PopupMenuItem<_CommunityPostMenuAction>(
                              value: _CommunityPostMenuAction.hide,
                              child: Text(l10n.communityHide),
                            ),
                            PopupMenuItem<_CommunityPostMenuAction>(
                              value: _CommunityPostMenuAction.block,
                              child: Text(l10n.communityBlockUser),
                            ),
                          ];
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  previewText,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (post.normalizedImageUrls.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _FeedImagePreview(imageUrls: post.normalizedImageUrls),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed: onLikePressed,
                      icon: Icon(
                        post.isLikedByMe
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 20,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                    Text('${post.likeCount}'),
                    const SizedBox(width: 12),
                    const Icon(Icons.chat_bubble_outline, size: 18),
                    const SizedBox(width: 6),
                    Text('${post.commentCount}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _CommunityPostMenuAction { report, hide, block }

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

class _CommunityAvatar extends StatelessWidget {
  const _CommunityAvatar({required this.imageUrl, required this.radius});

  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isValidUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    if (!isValidUrl) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        child: Icon(Icons.person_outline, size: radius),
      );
    }

    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, imageUrl) => CircleAvatar(
            radius: radius,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.person_outline, size: radius),
          ),
          errorWidget: (context, imageUrl, error) => CircleAvatar(
            radius: radius,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.person_outline, size: radius),
          ),
        ),
      ),
    );
  }
}

class _FeedImagePreview extends StatelessWidget {
  const _FeedImagePreview({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final firstImageUrl = imageUrls.first;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => showCommunityImageViewer(context, imageUrls: imageUrls),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: firstImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, imageUrl) =>
                    const ColoredBox(color: Colors.black12),
                errorWidget: (context, imageUrl, error) => const ColoredBox(
                  color: Colors.black12,
                  child: Center(child: Icon(Icons.broken_image_outlined)),
                ),
              ),
              if (imageUrls.length > 1)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        '+${imageUrls.length - 1}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityCoachBadge extends StatelessWidget {
  const _CommunityCoachBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
