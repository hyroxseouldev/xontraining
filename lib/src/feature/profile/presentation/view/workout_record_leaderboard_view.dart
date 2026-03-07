import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/workout_record_provider.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class WorkoutRecordLeaderboardView extends HookConsumerWidget {
  const WorkoutRecordLeaderboardView({super.key, required this.exerciseKey});

  final String exerciseKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final presetsState = ref.watch(workoutExercisePresetsProvider);
    final selectedPresetKey = useState<String?>(null);

    final exercisePresets = _presetsForExercise(
      presetsState.asData?.value,
      exerciseKey,
    );

    useEffect(() {
      if (exercisePresets.isEmpty) {
        selectedPresetKey.value = null;
        return null;
      }

      final current = selectedPresetKey.value;
      final containsCurrent = exercisePresets.any(
        (preset) => preset.presetKey == current,
      );
      if (!containsCurrent) {
        selectedPresetKey.value = exercisePresets.first.presetKey;
      }
      return null;
    }, [exercisePresets]);

    final presetKey = selectedPresetKey.value;
    final leaderboardState = presetKey == null
        ? const AsyncData<List<WorkoutLeaderboardEntryEntity>>(
            <WorkoutLeaderboardEntryEntity>[],
          )
        : ref.watch(
            workoutLeaderboardProvider(
              exerciseKey: exerciseKey,
              presetKey: presetKey,
              limit: 100,
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.workoutRecordLeaderboardTitle(_exerciseLabel(l10n, exerciseKey)),
        ),
      ),
      body: presetsState.when(
        data: (_) {
          if (exercisePresets.isEmpty) {
            return EmptyState(
              icon: _exerciseIcon(exerciseKey),
              message: l10n.workoutRecordLeaderboardEmpty,
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: DropdownButtonFormField<String>(
                  key: ValueKey(
                    'leaderboard-preset-${selectedPresetKey.value ?? 'none'}',
                  ),
                  initialValue: selectedPresetKey.value,
                  decoration: InputDecoration(
                    labelText: l10n.workoutRecordLeaderboardFilterPreset,
                  ),
                  items: exercisePresets
                      .map(
                        (preset) => DropdownMenuItem<String>(
                          value: preset.presetKey,
                          child: Text(_presetLabel(preset.presetKey)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    selectedPresetKey.value = value;
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: leaderboardState.when(
                  data: (entries) {
                    if (entries.isEmpty) {
                      return EmptyState(
                        icon: Icons.emoji_events_outlined,
                        message: l10n.workoutRecordLeaderboardEmpty,
                      );
                    }

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: RefreshIndicator(
                        key: ValueKey<String>(
                          'leaderboard-list-${selectedPresetKey.value ?? ''}',
                        ),
                        onRefresh: () async {
                          final provider = workoutLeaderboardProvider(
                            exerciseKey: exerciseKey,
                            presetKey: selectedPresetKey.value!,
                            limit: 100,
                          );
                          ref.invalidate(provider);
                          await ref.read(provider.future);
                        },
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: entries.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return _StaggeredFadeSlide(
                              index: index,
                              child: Card(
                                child: ListTile(
                                  leading: _RankBadge(rank: entry.rank),
                                  title: Row(
                                    children: [
                                      _LeaderboardAvatar(
                                        imageUrl: entry.normalizedUserAvatarUrl,
                                        displayName: entry.normalizedUserName,
                                        radius: 14,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          entry.normalizedUserName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    _primaryMetricLabel(entry),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  loading: () => const _LeaderboardLoadingSkeleton(),
                  error: (error, stackTrace) => Center(
                    child: Text(l10n.workoutRecordLeaderboardLoadFailed),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const _LeaderboardLoadingSkeleton(),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.workoutRecordLoadFailed)),
      ),
    );
  }

  List<WorkoutExercisePresetEntity> _presetsForExercise(
    List<WorkoutExercisePresetEntity>? presets,
    String targetKey,
  ) {
    if (presets == null) {
      return const [];
    }

    return presets
        .where((preset) => preset.exerciseKey == targetKey && preset.isActive)
        .toList(growable: false);
  }

  String _primaryMetricLabel(WorkoutLeaderboardEntryEntity entry) {
    if (entry.isTimeRecord) {
      return _durationLabel(entry.recordSeconds);
    }

    return _weightLabel(entry.recordWeightKg);
  }

  String _durationLabel(int? valueSeconds) {
    if (valueSeconds == null || valueSeconds <= 0) {
      return '0:00';
    }
    final minutes = valueSeconds ~/ 60;
    final seconds = valueSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _weightLabel(double? weight) {
    final value = weight ?? 0;
    if (value % 1 == 0) {
      return '${value.toInt()} kg';
    }
    return '${value.toStringAsFixed(2)} kg';
  }

  String _presetLabel(String presetKey) {
    final lower = presetKey.toLowerCase();
    if (lower.endsWith('rm')) {
      return lower.toUpperCase();
    }
    return presetKey;
  }

  IconData _exerciseIcon(String key) {
    switch (key) {
      case 'rowing':
        return Icons.rowing;
      case 'running':
        return Icons.directions_run;
      case 'ski':
        return Icons.downhill_skiing;
      case 'squat':
        return Icons.fitness_center;
      case 'deadlift':
        return Icons.sports_gymnastics;
      case 'bench_press':
        return Icons.sports_mma;
      default:
        return Icons.fitness_center;
    }
  }

  String _exerciseLabel(AppLocalizations l10n, String exerciseKey) {
    switch (exerciseKey) {
      case 'rowing':
        return l10n.workoutRecordTemplateRowing;
      case 'running':
        return l10n.workoutRecordTemplateRunning;
      case 'ski':
        return l10n.workoutRecordTemplateSki;
      case 'squat':
        return l10n.workoutRecordTemplateSquat;
      case 'deadlift':
        return l10n.workoutRecordTemplateDeadlift;
      case 'bench_press':
        return l10n.workoutRecordTemplateBenchPress;
      default:
        return exerciseKey;
    }
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rankColors = _rankColors(colorScheme, rank);
    final isTopThree = rank <= 3;
    final badge = Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: rankColors.background,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: isTopThree
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 13,
                  color: rankColors.foreground,
                ),
                Text(
                  '$rank',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: rankColors.foreground,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ],
            )
          : Text(
              '$rank',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: rankColors.foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
    );

    if (!isTopThree) {
      return badge;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.82, end: 1),
      duration: Duration(milliseconds: 520 + (rank * 80)),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: badge,
    );
  }

  _BadgeColors _rankColors(ColorScheme colorScheme, int value) {
    switch (value) {
      case 1:
        return const _BadgeColors(
          background: Color(0xFFFFD54F),
          foreground: Color(0xFF4E342E),
        );
      case 2:
        return const _BadgeColors(
          background: Color(0xFFCFD8DC),
          foreground: Color(0xFF37474F),
        );
      case 3:
        return const _BadgeColors(
          background: Color(0xFFFFB74D),
          foreground: Color(0xFF4E342E),
        );
      default:
        return _BadgeColors(
          background: colorScheme.primaryContainer,
          foreground: colorScheme.onPrimaryContainer,
        );
    }
  }
}

class _BadgeColors {
  const _BadgeColors({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

class _LeaderboardAvatar extends StatelessWidget {
  const _LeaderboardAvatar({
    required this.imageUrl,
    required this.displayName,
    this.radius = 17,
  });

  final String imageUrl;
  final String displayName;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(imageUrl);
    final isValidUrl =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    final fallback = CircleAvatar(
      radius: radius,
      child: Text(
        _initial(displayName),
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );

    if (!isValidUrl) {
      return fallback;
    }

    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => fallback,
          errorWidget: (context, url, error) => fallback,
        ),
      ),
    );
  }

  String _initial(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed.characters.first.toUpperCase();
  }
}

class _StaggeredFadeSlide extends StatelessWidget {
  const _StaggeredFadeSlide({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 280 + (index * 45)),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}

class _LeaderboardLoadingSkeleton extends StatelessWidget {
  const _LeaderboardLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: 8,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const _ShimmerBox(width: 42, height: 42, isCircle: true),
                const SizedBox(width: 8),
                const _ShimmerBox(width: 34, height: 34, isCircle: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _ShimmerBox(height: 14, width: 120),
                      SizedBox(height: 8),
                      _ShimmerBox(height: 12),
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

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({this.width, this.height, this.isCircle = false});

  final double? width;
  final double? height;
  final bool isCircle;

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
      duration: const Duration(milliseconds: 1200),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.width ?? constraints.maxWidth;
        final height = widget.height ?? constraints.maxHeight;

        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.isCircle ? 999 : 8),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final shimmerWidth = width * 0.7;
              final shimmerX =
                  ((width + shimmerWidth) * _controller.value) - shimmerWidth;
              return SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    ColoredBox(color: baseColor),
                    Positioned(
                      left: shimmerX,
                      top: 0,
                      bottom: 0,
                      width: shimmerWidth,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              highlightColor.withValues(alpha: 0),
                              highlightColor.withValues(alpha: 0.7),
                              highlightColor.withValues(alpha: 0),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
