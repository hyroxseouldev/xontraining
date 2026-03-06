import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/community/infra/entity/community_entity.dart';
import 'package:xontraining/src/feature/community/presentation/provider/community_provider.dart';
import 'package:xontraining/src/feature/community/presentation/view/community_view_helper.dart';
import 'package:xontraining/src/feature/community/presentation/widget/community_image_viewer.dart';
import 'package:xontraining/src/feature/community/presentation/widget/community_skeleton.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class CommunityView extends HookConsumerWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final feedState = ref.watch(communityFeedControllerProvider);
    final scrollController = useScrollController();

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoutes.communityWriteName),
        icon: const Icon(Icons.edit_outlined),
        label: Text(l10n.communityWrite),
      ),
      body: feedState.when(
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
            onRefresh: () =>
                ref.read(communityFeedControllerProvider.notifier).refresh(),
            child: ListView.separated(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
              itemCount:
                  feed.items.length +
                  ((feed.isLoadingMore || feed.hasLoadMoreError) ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index >= feed.items.length) {
                  if (feed.hasLoadMoreError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: OutlinedButton.icon(
                          onPressed: () => ref
                              .read(communityFeedControllerProvider.notifier)
                              .retryLoadMore(),
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.communityRetry),
                        ),
                      ),
                    );
                  }

                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final post = feed.items[index];
                return _CommunityPostCard(
                  post: post,
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.communityDetailName,
                      pathParameters: {'postId': post.id},
                    );
                  },
                  onLikePressed: () {
                    ref
                        .read(communityActionControllerProvider.notifier)
                        .toggleLike(
                          postId: post.id,
                          currentLike: post.isLikedByMe,
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

class _CommunityPostCard extends StatelessWidget {
  const _CommunityPostCard({
    required this.post,
    required this.onTap,
    required this.onLikePressed,
  });

  final CommunityPostEntity post;
  final VoidCallback onTap;
  final VoidCallback onLikePressed;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;
    final dateText = DateFormat(
      'MMMM dd, yyyy, HH:mm',
      locale.languageCode,
    ).format(post.createdAt.toLocal());
    final timeAgo = buildCommunityTimeAgo(
      createdAt: post.createdAt,
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
                          Text(
                            post.normalizedAuthorName,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$dateText · $timeAgo',
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
                placeholder: (context, imageUrl) => const ColoredBox(
                  color: Colors.black12,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
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
