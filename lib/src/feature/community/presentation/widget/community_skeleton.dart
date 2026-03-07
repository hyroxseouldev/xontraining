import 'package:flutter/material.dart';
import 'package:xontraining/src/shared/layout_breakpoints.dart';

class CommunityFeedLoadingSkeleton extends StatelessWidget {
  const CommunityFeedLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = LayoutBreakpoints.isTablet(context);
    if (!isTablet) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => const _FeedSkeletonCard(),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const _FeedSkeletonCard(),
    );
  }
}

class CommunityDetailLoadingSkeleton extends StatelessWidget {
  const CommunityDetailLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: const [
        _FeedSkeletonCard(),
        SizedBox(height: 16),
        CommunityShimmerBox(height: 18, width: 96),
        SizedBox(height: 8),
        _CommentSkeletonCard(),
        SizedBox(height: 8),
        _CommentSkeletonCard(),
        SizedBox(height: 8),
        _CommentSkeletonCard(),
      ],
    );
  }
}

class CommunityCommentLoadingSkeleton extends StatelessWidget {
  const CommunityCommentLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _CommentSkeletonCard(),
        SizedBox(height: 8),
        _CommentSkeletonCard(),
      ],
    );
  }
}

class _FeedSkeletonCard extends StatelessWidget {
  const _FeedSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommunityShimmerBox(height: 32, width: 32, isCircle: true),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommunityShimmerBox(height: 14, width: 120),
                    SizedBox(height: 6),
                    CommunityShimmerBox(height: 12, width: 180),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          CommunityShimmerBox(height: 14),
          SizedBox(height: 8),
          CommunityShimmerBox(height: 14, width: 240),
          SizedBox(height: 10),
          CommunityShimmerBox(height: 160),
          SizedBox(height: 10),
          CommunityShimmerBox(height: 24, width: 150),
        ],
      ),
    );
  }
}

class _CommentSkeletonCard extends StatelessWidget {
  const _CommentSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommunityShimmerBox(height: 28, width: 28, isCircle: true),
              SizedBox(width: 8),
              CommunityShimmerBox(height: 13, width: 110),
              SizedBox(width: 8),
              Expanded(child: SizedBox()),
              CommunityShimmerBox(height: 12, width: 96),
            ],
          ),
          SizedBox(height: 8),
          CommunityShimmerBox(height: 14),
        ],
      ),
    );
  }
}

class CommunityShimmerBox extends StatefulWidget {
  const CommunityShimmerBox({
    this.height,
    this.width,
    this.isCircle = false,
    super.key,
  });

  final double? height;
  final double? width;
  final bool isCircle;

  @override
  State<CommunityShimmerBox> createState() => _CommunityShimmerBoxState();
}

class _CommunityShimmerBoxState extends State<CommunityShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
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
    final highlightColor = Theme.of(context).colorScheme.surface;
    final borderRadius = widget.isCircle ? null : BorderRadius.circular(8);

    return SizedBox(
      width: widget.width,
      height: widget.height ?? 12,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(999),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
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
                            colors: [
                              highlightColor.withValues(alpha: 0),
                              highlightColor.withValues(alpha: 0.6),
                              highlightColor.withValues(alpha: 0),
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
        ),
      ),
    );
  }
}
