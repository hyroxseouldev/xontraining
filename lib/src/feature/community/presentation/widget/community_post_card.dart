import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/community/infra/entity/community_entity.dart';
import 'package:xontraining/src/feature/community/presentation/view/community_view_helper.dart';
import 'package:xontraining/src/feature/community/presentation/widget/community_image_viewer.dart';

class CommunityPostCard extends StatelessWidget {
  const CommunityPostCard({
    required this.post,
    required this.isMine,
    required this.onTap,
    required this.onLikePressed,
    this.onEditPressed,
    this.onDeletePressed,
    this.onReportPressed,
    this.onHidePressed,
    this.onBlockUserPressed,
    super.key,
  });

  final CommunityPostEntity post;
  final bool isMine;
  final VoidCallback onTap;
  final VoidCallback onLikePressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onReportPressed;
  final VoidCallback? onHidePressed;
  final VoidCallback? onBlockUserPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final previewText = communityHtmlToPlainText(post.normalizedContent);
    final timeAgoLabel = buildCommunityTimeAgo(
      createdAt: post.createdAt,
      now: DateTime.now(),
      l10n: l10n,
    );
    const avatarRadius = 18.0;
    const headerGap = 10.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
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
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                              height: 1.2,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuButton<_CommunityPostMenuAction>(
                                onSelected: (value) {
                                  switch (value) {
                                    case _CommunityPostMenuAction.edit:
                                      onEditPressed?.call();
                                      return;
                                    case _CommunityPostMenuAction.delete:
                                      onDeletePressed?.call();
                                      return;
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
                                  if (isMine) {
                                    return [
                                      PopupMenuItem<_CommunityPostMenuAction>(
                                        value: _CommunityPostMenuAction.edit,
                                        child: Text(l10n.communityEdit),
                                      ),
                                      PopupMenuItem<_CommunityPostMenuAction>(
                                        value: _CommunityPostMenuAction.delete,
                                        child: Text(l10n.communityDelete),
                                      ),
                                    ];
                                  }
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
                          Text(
                            previewText,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (post.normalizedImageUrls.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            CommunityFeedImagePreview(
                              imageUrls: post.normalizedImageUrls,
                            ),
                          ],
                          const SizedBox(height: 8),
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
                                        size: 16,
                                        color: post.isLikedByMe
                                            ? colorScheme.error
                                            : colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${post.likeCount}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 15,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${post.commentCount}',
                                style: Theme.of(context).textTheme.labelMedium,
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
      ),
    );
  }
}

class CommunityAvatar extends StatelessWidget {
  const CommunityAvatar({
    required this.imageUrl,
    required this.radius,
    super.key,
  });

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

class CommunityFeedImagePreview extends StatelessWidget {
  const CommunityFeedImagePreview({required this.imageUrls, super.key});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrl = imageUrls.first;
    final remainingCount = imageUrls.length - 1;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => showCommunityImageViewer(context, imageUrls: imageUrls),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, imageUrl) =>
                    ColoredBox(color: colorScheme.surfaceContainerHighest),
                errorWidget: (context, imageUrl, error) => ColoredBox(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.04),
                      Colors.black.withValues(alpha: 0.28),
                    ],
                  ),
                ),
              ),
              if (remainingCount > 0)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '+$remainingCount',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
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

class CommunityCoachBadge extends StatelessWidget {
  const CommunityCoachBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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

enum _CommunityPostMenuAction { edit, delete, report, hide, block }
