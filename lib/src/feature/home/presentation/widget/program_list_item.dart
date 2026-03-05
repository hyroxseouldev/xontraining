import 'package:flutter/material.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';

class ProgramListItem extends StatelessWidget {
  const ProgramListItem({required this.program, super.key});

  final ProgramEntity program;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final durationText = _durationText(
      program.startDate,
      program.endDate,
      l10n,
    );
    final difficultyText = _valueOrFallback(program.difficulty, l10n);
    final workoutTimeText = program.dailyWorkoutMinutes == null
        ? l10n.homeProgramValueNotAvailable
        : l10n.homeProgramWorkoutMinutes(program.dailyWorkoutMinutes!);
    final weeklySessionsText = program.daysPerWeek == null
        ? l10n.homeProgramValueNotAvailable
        : l10n.homeProgramWeeklySessions(program.daysPerWeek!);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Thumbnail(url: program.thumbnailUrl),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.title,
                  style: Theme.of(context).textTheme.titleMedium,
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
                if ((program.description ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    program.description!.trim(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _durationText(
  DateTime? startDate,
  DateTime? endDate,
  AppLocalizations l10n,
) {
  if (startDate == null || endDate == null) {
    return l10n.homeProgramValueNotAvailable;
  }

  final days = endDate.difference(startDate).inDays.abs() + 1;
  final weeks = (days / 7).ceil().clamp(1, 999);
  return l10n.homeProgramDurationWeeks(weeks);
}

String _valueOrFallback(String? value, AppLocalizations l10n) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return l10n.homeProgramValueNotAvailable;
  }
  return trimmed;
}

class _InfoItem {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;
}

class _InfoList extends StatelessWidget {
  const _InfoList({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium;
    final valueStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(child: Text(item.label, style: labelStyle)),
                  const SizedBox(width: 12),
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

  final String? url;

  @override
  Widget build(BuildContext context) {
    final value = url?.trim() ?? '';
    if (value.isEmpty) {
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
      child: Image.network(
        value,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image_outlined),
          );
        },
      ),
    );
  }
}
