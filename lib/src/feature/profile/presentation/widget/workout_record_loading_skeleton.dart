import 'package:flutter/material.dart';
import 'package:xontraining/src/shared/layout_breakpoints.dart';

class WorkoutRecordGridLoadingSkeleton extends StatelessWidget {
  const WorkoutRecordGridLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = LayoutBreakpoints.isTablet(context);

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 6 : 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isTablet ? 0.95 : 0.9,
      ),
      itemCount: isTablet ? 12 : 6,
      itemBuilder: (context, index) {
        return const Card(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _WorkoutRecordShimmerBox(width: 36, height: 36, isCircle: true),
                SizedBox(height: 12),
                _WorkoutRecordShimmerBox(height: 14, width: 68),
                SizedBox(height: 6),
                _WorkoutRecordShimmerBox(height: 12, width: 44),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WorkoutRecordListLoadingSkeleton extends StatelessWidget {
  const WorkoutRecordListLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return const Card(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                _WorkoutRecordShimmerBox(width: 20, height: 20, isCircle: true),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WorkoutRecordShimmerBox(height: 15, width: 180),
                      SizedBox(height: 8),
                      _WorkoutRecordShimmerBox(height: 12, width: 140),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WorkoutRecordShimmerBox extends StatefulWidget {
  const _WorkoutRecordShimmerBox({
    this.width,
    this.height,
    this.isCircle = false,
  });

  final double? width;
  final double? height;
  final bool isCircle;

  @override
  State<_WorkoutRecordShimmerBox> createState() =>
      _WorkoutRecordShimmerBoxState();
}

class _WorkoutRecordShimmerBoxState extends State<_WorkoutRecordShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
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

    return SizedBox(
      width: widget.width,
      height: widget.height ?? 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.isCircle ? 999 : 8),
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
