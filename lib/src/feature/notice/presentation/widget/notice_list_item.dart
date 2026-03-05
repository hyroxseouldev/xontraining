import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/src/feature/notice/infra/entity/notice_entity.dart';

class NoticeListItem extends HookWidget {
  const NoticeListItem({required this.notice, this.onTap, super.key});

  final NoticeEntity notice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final notice = this.notice;
    final isPressed = useState(false);

    final titleStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      scale: isPressed.value ? 0.985 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onHighlightChanged: (value) {
            isPressed.value = value;
          },
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NoticeThumbnail(url: notice.normalizedThumbnailUrl),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.normalizedTitle,
                        style: titleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat(
                          'MMMM, dd, yyyy',
                        ).format(notice.createdAt.toLocal()),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoticeThumbnail extends StatelessWidget {
  const _NoticeThumbnail({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    if (url.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.campaign_outlined),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(14),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: url,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, imageUrl) =>
                  const _NoticeThumbnailSkeleton(),
              errorWidget: (context, imageUrl, error) {
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image_outlined),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NoticeThumbnailSkeleton extends StatefulWidget {
  const _NoticeThumbnailSkeleton();

  @override
  State<_NoticeThumbnailSkeleton> createState() =>
      _NoticeThumbnailSkeletonState();
}

class _NoticeThumbnailSkeletonState extends State<_NoticeThumbnailSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final shimmerX = (width * 2 * _controller.value) - width;

            return Stack(
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
            );
          },
        );
      },
    );
  }
}
