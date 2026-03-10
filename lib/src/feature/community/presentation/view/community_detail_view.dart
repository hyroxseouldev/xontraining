import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
import 'package:xontraining/src/feature/community/presentation/widget/community_post_card.dart';
import 'package:xontraining/src/feature/community/presentation/widget/community_skeleton.dart';
import 'package:xontraining/src/shared/empty_state.dart';

const List<String> _restrictedCommunityTerms = <String>[
  'porn',
  'nude',
  '성인',
  '음란',
  '혐오',
  'kill',
];

class CommunityDetailView extends ConsumerStatefulWidget {
  const CommunityDetailView({required this.postId, super.key});

  final String postId;

  @override
  ConsumerState<CommunityDetailView> createState() =>
      _CommunityDetailViewState();
}

class _CommunityDetailViewState extends ConsumerState<CommunityDetailView> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final minimalEnabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );
    final minimalFocusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
    );
    final accessState = ref.watch(communityAccessProvider);
    final hasCommunityAccess = accessState.asData?.value ?? false;
    final detailState = hasCommunityAccess
        ? ref.watch(communityPostDetailProvider(widget.postId))
        : const AsyncLoading<CommunityPostEntity>();
    final commentsState = hasCommunityAccess
        ? ref.watch(communityCommentsProvider(widget.postId))
        : const AsyncData<List<CommunityCommentEntity>>(
            <CommunityCommentEntity>[],
          );
    final actionState = ref.watch(communityActionControllerProvider);
    final currentUserId = ref.watch(authSessionProvider).asData?.value?.id;

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
      appBar: AppBar(toolbarHeight: 56),
      body: accessState.when(
        loading: () => const CommunityDetailLoadingSkeleton(),
        error: (error, stackTrace) =>
            EmptyState(message: l10n.communityLoadFailed),
        data: (canAccess) {
          if (!canAccess) {
            return EmptyState(
              message: l10n.communityMembershipRequired,
              icon: Icons.lock_outline,
            );
          }

          return detailState.when(
            loading: () => const CommunityDetailLoadingSkeleton(),
            error: (error, stackTrace) =>
                EmptyState(message: l10n.communityLoadFailed),
            data: (post) {
              final isMyPost =
                  currentUserId != null && currentUserId == post.authorId;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      children: [
                        _PostHeader(
                          post: post,
                          isMyPost: isMyPost,
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
                          onEditPressed: () {
                            context.pushNamed(
                              AppRoutes.communityEditName,
                              pathParameters: {'postId': post.id},
                              extra: {
                                'content': post.normalizedContent,
                                'images': post.normalizedImageUrls,
                              },
                            );
                          },
                          onDeletePressed: () => _onDeletePostPressed(
                            context,
                            post.id,
                            post.normalizedImageUrls,
                          ),
                          onReportPressed: () =>
                              _onReportPostPressed(context, postId: post.id),
                          onHidePressed: () =>
                              _onHidePostPressed(context, postId: post.id),
                          onBlockAuthorPressed: () => _onBlockAuthorPressed(
                            context,
                            authorId: post.authorId,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.communityComments,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        commentsState.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: CommunityCommentLoadingSkeleton(),
                          ),
                          error: (error, stackTrace) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              l10n.communityCommentLoadFailed,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          data: (comments) {
                            if (comments.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  l10n.communityCommentEmpty,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            }
                            return Column(
                              children: comments
                                  .map(
                                    (comment) => _CommentItem(
                                      comment: comment,
                                      isMine: currentUserId == comment.authorId,
                                      onDeletePressed: () =>
                                          _onDeleteCommentPressed(
                                            context,
                                            commentId: comment.id,
                                          ),
                                      onReportPressed: () =>
                                          _onReportCommentPressed(
                                            context,
                                            commentId: comment.id,
                                          ),
                                    ),
                                  )
                                  .toList(growable: false),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  enabled: !actionState.isLoading,
                                  maxLines: 3,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    hintText: l10n.communityCommentHint,
                                    filled: false,
                                    enabledBorder: minimalEnabledBorder,
                                    focusedBorder: minimalFocusedBorder,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: actionState.isLoading
                                    ? null
                                    : () => _onCommentSubmitPressed(context),
                                child: Text(l10n.communityCommentSend),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.communityCommentGuideline,
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
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _onDeletePostPressed(
    BuildContext context,
    String postId,
    List<String> imageUrls,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.communityDeletePostTitle),
          content: Text(l10n.communityDeletePostBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.communityCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.communityDelete),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await ref
        .read(communityActionControllerProvider.notifier)
        .deletePost(postId: postId, imageUrls: imageUrls);
    if (!context.mounted) {
      return;
    }
    if (!ref.read(communityActionControllerProvider).hasError) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _onDeleteCommentPressed(
    BuildContext context, {
    required String commentId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    await ref
        .read(communityActionControllerProvider.notifier)
        .deleteComment(postId: widget.postId, commentId: commentId);
    if (!context.mounted) {
      return;
    }
    if (!ref.read(communityActionControllerProvider).hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityCommentDeleted)));
    }
  }

  Future<void> _onReportPostPressed(
    BuildContext context, {
    required String postId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final report = await _showCommunityReportDialog(context);
    if (report == null || !context.mounted) {
      return;
    }

    await ref
        .read(communityActionControllerProvider.notifier)
        .reportPost(
          postId: postId,
          reason: report.reason,
          detail: report.detail,
        );
    if (!context.mounted) {
      return;
    }
    if (!ref.read(communityActionControllerProvider).hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityReportSubmitted)));
    }
  }

  Future<void> _onHidePostPressed(
    BuildContext context, {
    required String postId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _showCommunityConfirmDialog(
      context,
      title: l10n.communityHidePostTitle,
      body: l10n.communityHidePostBody,
      confirmText: l10n.communityHide,
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    await ref
        .read(communityActionControllerProvider.notifier)
        .hidePost(postId: postId);
    if (!context.mounted) {
      return;
    }
    if (!ref.read(communityActionControllerProvider).hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityPostHidden)));
      Navigator.of(context).pop();
    }
  }

  Future<void> _onBlockAuthorPressed(
    BuildContext context, {
    required String authorId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await _showCommunityConfirmDialog(
      context,
      title: l10n.communityBlockUserTitle,
      body: l10n.communityBlockUserBody,
      confirmText: l10n.communityBlockUser,
    );
    if (!confirmed || !context.mounted) {
      return;
    }

    await ref
        .read(communityActionControllerProvider.notifier)
        .blockUser(blockedUserId: authorId, postId: widget.postId);
    if (!context.mounted) {
      return;
    }
    if (!ref.read(communityActionControllerProvider).hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityUserBlocked)));
      Navigator.of(context).pop();
    }
  }

  Future<void> _onReportCommentPressed(
    BuildContext context, {
    required String commentId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final report = await _showCommunityReportDialog(context);
    if (report == null || !context.mounted) {
      return;
    }

    await ref
        .read(communityActionControllerProvider.notifier)
        .reportComment(
          postId: widget.postId,
          commentId: commentId,
          reason: report.reason,
          detail: report.detail,
        );
    if (!context.mounted) {
      return;
    }
    if (!ref.read(communityActionControllerProvider).hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityReportSubmitted)));
    }
  }

  Future<void> _onCommentSubmitPressed(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final content = _commentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityCommentRequired)));
      return;
    }
    if (_containsRestrictedTerms(content)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.communityCommentRestricted)));
      return;
    }

    await ref
        .read(communityActionControllerProvider.notifier)
        .createComment(postId: widget.postId, content: content);
    if (!mounted) {
      return;
    }
    if (!ref.read(communityActionControllerProvider).hasError) {
      _commentController.clear();
    }
  }

  bool _containsRestrictedTerms(String content) {
    final normalized = content.toLowerCase();
    for (final term in _restrictedCommunityTerms) {
      if (normalized.contains(term)) {
        return true;
      }
    }
    return false;
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.post,
    required this.isMyPost,
    required this.onLikePressed,
    required this.onEditPressed,
    required this.onDeletePressed,
    required this.onReportPressed,
    required this.onHidePressed,
    required this.onBlockAuthorPressed,
  });

  final CommunityPostEntity post;
  final bool isMyPost;
  final VoidCallback onLikePressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onReportPressed;
  final VoidCallback onHidePressed;
  final VoidCallback onBlockAuthorPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final timeAgoLabel = buildCommunityTimeAgo(
      createdAt: post.createdAt,
      now: DateTime.now(),
      l10n: l10n,
    );
    final colorScheme = Theme.of(context).colorScheme;
    const avatarRadius = 18.0;
    const headerGap = 10.0;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommunityAvatar(
                    imageUrl: post.normalizedAuthorAvatarUrl,
                    radius: avatarRadius,
                  ),
                  const SizedBox(width: headerGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (post.hasCoachBadge) ...[
                              CommunityCoachBadge(
                                label: l10n.communityCoachBadge,
                              ),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: post.normalizedAuthorName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: colorScheme.onSurface,
                                            height: 1.2,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' · $timeAgoLabel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            height: 1.2,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  onEditPressed();
                                  return;
                                }
                                if (value == 'delete') {
                                  onDeletePressed();
                                  return;
                                }
                                if (value == 'report') {
                                  onReportPressed();
                                  return;
                                }
                                if (value == 'hide') {
                                  onHidePressed();
                                  return;
                                }
                                onBlockAuthorPressed();
                              },
                              itemBuilder: (context) {
                                final l10n = AppLocalizations.of(context)!;
                                if (isMyPost) {
                                  return [
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text(l10n.communityEdit),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text(l10n.communityDelete),
                                    ),
                                  ];
                                }
                                return [
                                  PopupMenuItem<String>(
                                    value: 'report',
                                    child: Text(l10n.communityReport),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'hide',
                                    child: Text(l10n.communityHide),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'block',
                                    child: Text(l10n.communityBlockUser),
                                  ),
                                ];
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Center(
                                  child: Icon(
                                    Icons.more_horiz_rounded,
                                    size: 18,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        DefaultTextStyle.merge(
                          style: Theme.of(context).textTheme.bodyLarge,
                          child: Html(
                            data: post.normalizedContent,
                            style: {
                              'body': Style(
                                margin: Margins.zero,
                                padding: HtmlPaddings.zero,
                                color: colorScheme.onSurface,
                                fontSize: FontSize(16),
                                lineHeight: const LineHeight(1.45),
                              ),
                              'p': Style(margin: Margins.only(bottom: 10)),
                            },
                          ),
                        ),
                        if (post.normalizedImageUrls.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _DetailImageGallery(
                            imageUrls: post.normalizedImageUrls,
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: onLikePressed,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      post.isLikedByMe
                                          ? Icons.favorite_rounded
                                          : Icons.favorite_border_rounded,
                                      size: 18,
                                      color: post.isLikedByMe
                                          ? colorScheme.error
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${post.likeCount}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 17,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${post.commentCount}',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailImageGallery extends StatelessWidget {
  const _DetailImageGallery({required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => showCommunityImageViewer(
              context,
              imageUrls: imageUrls,
              initialIndex: index,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, imageUrl) => ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                      ),
                      errorWidget: (context, imageUrl, error) => ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.03),
                            Colors.black.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CommentAvatar extends StatelessWidget {
  const _CommentAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final isValidUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    if (!isValidUrl) {
      return const CircleAvatar(
        radius: 14,
        backgroundColor: Colors.transparent,
        child: Icon(Icons.person_outline, size: 14),
      );
    }

    return ClipOval(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, imageUrl) => const CircleAvatar(
            radius: 14,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.person_outline, size: 14),
          ),
          errorWidget: (context, imageUrl, error) => const CircleAvatar(
            radius: 14,
            backgroundColor: Colors.transparent,
            child: Icon(Icons.person_outline, size: 14),
          ),
        ),
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  const _CommentItem({
    required this.comment,
    required this.isMine,
    required this.onDeletePressed,
    required this.onReportPressed,
  });

  final CommunityCommentEntity comment;
  final bool isMine;
  final VoidCallback onDeletePressed;
  final VoidCallback onReportPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final timeAgoLabel = buildCommunityTimeAgo(
      createdAt: comment.createdAt,
      now: DateTime.now(),
      l10n: l10n,
    );

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CommentAvatar(imageUrl: comment.normalizedAuthorAvatarUrl),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (comment.hasCoachBadge) ...[
                              CommunityCoachBadge(
                                label: l10n.communityCoachBadge,
                              ),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: comment.normalizedAuthorName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                            height: 1.2,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' · $timeAgoLabel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            height: 1.2,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'delete') {
                                  onDeletePressed();
                                  return;
                                }
                                onReportPressed();
                              },
                              itemBuilder: (context) {
                                final l10n = AppLocalizations.of(context)!;
                                if (isMine) {
                                  return [
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text(l10n.communityDelete),
                                    ),
                                  ];
                                }
                                return [
                                  PopupMenuItem<String>(
                                    value: 'report',
                                    child: Text(l10n.communityReport),
                                  ),
                                ];
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Center(
                                  child: Icon(
                                    Icons.more_horiz_rounded,
                                    size: 18,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(comment.normalizedContent),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

Future<_CommunityReportDialogResult?> _showCommunityReportDialog(
  BuildContext context,
) async {
  final l10n = AppLocalizations.of(context)!;
  final colorScheme = Theme.of(context).colorScheme;
  final minimalEnabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.outlineVariant),
  );
  final minimalFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
  );
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
                    filled: false,
                    enabledBorder: minimalEnabledBorder,
                    focusedBorder: minimalFocusedBorder,
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

Future<bool> _showCommunityConfirmDialog(
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
