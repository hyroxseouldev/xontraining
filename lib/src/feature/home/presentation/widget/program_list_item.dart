import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';

class ProgramListItem extends StatefulWidget {
  const ProgramListItem({required this.program, this.onTap, super.key});

  final ProgramEntity program;
  final VoidCallback? onTap;

  @override
  State<ProgramListItem> createState() => _ProgramListItemState();
}

class _ProgramListItemState extends State<ProgramListItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final program = widget.program;
    final notAvailableText = l10n.homeProgramValueNotAvailable;
    final durationText = program.durationWeeks == null
        ? notAvailableText
        : l10n.homeProgramDurationWeeks(program.durationWeeks!);
    final difficultyText = program.hasDifficulty
        ? _localizedDifficulty(program.normalizedDifficulty, l10n)
        : notAvailableText;
    final workoutTimeText = program.dailyWorkoutMinutes == null
        ? notAvailableText
        : l10n.homeProgramWorkoutMinutes(program.dailyWorkoutMinutes!);
    final weeklySessionsText = program.daysPerWeek == null
        ? notAvailableText
        : l10n.homeProgramWeeklySessions(program.daysPerWeek!);

    final titleStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);
    final descriptionStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      height: 1.4,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return AnimatedScale(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      scale: _isPressed ? 0.985 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (value) {
            setState(() {
              _isPressed = value;
            });
          },
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Thumbnail(url: program.normalizedThumbnailUrl),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        program.title,
                        style: titleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      _InfoList(
                        items: [
                          _InfoItem(
                            label: l10n.homeProgramInfoDuration,
                            value: durationText,
                          ),
                          _InfoItem(
                            label: l10n.homeProgramInfoDifficulty,
                            value: difficultyText,
                            isBadge: true,
                            isPlaceholder: !program.hasDifficulty,
                          ),
                          _InfoItem(
                            label: l10n.homeProgramInfoWorkoutTime,
                            value: workoutTimeText,
                          ),
                          _InfoItem(
                            label: l10n.homeProgramInfoWeeklySessions,
                            value: weeklySessionsText,
                          ),
                        ],
                      ),
                      if (program.hasDescription) ...[
                        const SizedBox(height: 10),
                        Text(
                          program.normalizedDescription,
                          style: descriptionStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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

class _InfoItem {
  const _InfoItem({
    required this.label,
    required this.value,
    this.isBadge = false,
    this.isPlaceholder = false,
  });

  final String label;
  final String value;
  final bool isBadge;
  final bool isPlaceholder;
}

class _InfoList extends StatelessWidget {
  const _InfoList({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    final valueStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(item.label, style: labelStyle)),
                  const SizedBox(width: 12),
                  if (item.isBadge && !item.isPlaceholder)
                    _DifficultyBadge(text: item.value)
                  else
                    Text(item.value, style: valueStyle),
                ],
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.image_not_supported_outlined),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, imageUrl) => const _ThumbnailSkeleton(),
        errorWidget: (context, imageUrl, error) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image_outlined),
          );
        },
      ),
    );
  }
}

class _ThumbnailSkeleton extends StatefulWidget {
  const _ThumbnailSkeleton();

  @override
  State<_ThumbnailSkeleton> createState() => _ThumbnailSkeletonState();
}

class _ThumbnailSkeletonState extends State<_ThumbnailSkeleton>
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

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

String _localizedDifficulty(String raw, AppLocalizations l10n) {
  final normalized = raw.trim().toLowerCase().replaceAll(
    RegExp(r'[-_\s]+'),
    '',
  );
  switch (normalized) {
    case 'beginner':
    case 'easy':
    case 'starter':
    case 'novice':
    case '초급':
      return l10n.homeProgramDifficultyBeginner;
    case 'intermediate':
    case 'medium':
    case 'mid':
    case '중급':
      return l10n.homeProgramDifficultyIntermediate;
    case 'advanced':
    case 'hard':
    case 'expert':
    case '고급':
      return l10n.homeProgramDifficultyAdvanced;
    default:
      return raw;
  }
}
