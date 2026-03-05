import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/presentation/provider/home_controller.dart';
import 'package:xontraining/src/feature/home/presentation/widget/program_list_item.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final homeState = ref.watch(homeControllerProvider);

    ref.listen<AsyncValue<List<ProgramEntity>>>(homeControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.homeLoadFailed)));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        leading: IconButton(
          onPressed: () => context.pushNamed(AppRoutes.profileName),
          icon: const Icon(Icons.person_outline),
          tooltip: l10n.homeProfile,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                l10n.homeProgramsTitle,
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
      body: homeState.when(
        loading: () => const _HomeLoadingSkeleton(),
        error: (error, stackTrace) => EmptyState(message: l10n.homeLoadFailed),
        data: (programs) {
          if (programs.isEmpty) {
            return EmptyState(
              message: l10n.homeNoPrograms,
              icon: Icons.event_busy_outlined,
            );
          }

          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: programs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final program = programs[index];
              return ProgramListItem(
                program: program,
                onTap: () {
                  context.pushNamed(
                    AppRoutes.programDetailName,
                    pathParameters: {'programId': program.id},
                    extra: program,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeLoadingSkeleton extends StatelessWidget {
  const _HomeLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => const _ProgramListItemSkeleton(),
    );
  }
}

class _ProgramListItemSkeleton extends StatelessWidget {
  const _ProgramListItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(aspectRatio: 1, child: _ShimmerBox()),
        Padding(
          padding: EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(height: 22, width: 180),
              SizedBox(height: 12),
              _SkeletonInfoRow(),
              SizedBox(height: 8),
              _SkeletonInfoRow(),
              SizedBox(height: 8),
              _SkeletonInfoRow(),
              SizedBox(height: 8),
              _SkeletonInfoRow(),
              SizedBox(height: 12),
              _ShimmerBox(height: 14),
              SizedBox(height: 8),
              _ShimmerBox(height: 14, width: 220),
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
        Expanded(child: _ShimmerBox(height: 14)),
        SizedBox(width: 12),
        _ShimmerBox(height: 14, width: 88),
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
