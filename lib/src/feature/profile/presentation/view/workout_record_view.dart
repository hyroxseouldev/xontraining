import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';

class WorkoutRecordView extends ConsumerWidget {
  const WorkoutRecordView({super.key});

  static const List<_WorkoutTemplate> _templates = [
    _WorkoutTemplate(key: 'rowing', icon: Icons.rowing, cardio: true),
    _WorkoutTemplate(key: 'running', icon: Icons.directions_run, cardio: true),
    _WorkoutTemplate(key: 'ski', icon: Icons.downhill_skiing, cardio: true),
    _WorkoutTemplate(key: 'squat', icon: Icons.fitness_center, cardio: false),
    _WorkoutTemplate(
      key: 'deadlift',
      icon: Icons.sports_gymnastics,
      cardio: false,
    ),
    _WorkoutTemplate(key: 'bench_press', icon: Icons.sports_mma, cardio: false),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

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
                l10n.profileWorkoutRecord,
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
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.92,
        ),
        itemCount: _templates.length,
        itemBuilder: (context, index) {
          final template = _templates[index];
          final iconColor = template.cardio
              ? colorScheme.primary
              : colorScheme.secondary;
          final iconBackground = template.cardio
              ? colorScheme.primaryContainer
              : colorScheme.secondaryContainer;

          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.pushNamed(
                AppRoutes.workoutRecordEntryName,
                pathParameters: {'exercise': template.key},
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: iconBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(template.icon, color: iconColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _templateLabel(l10n, template.key),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      template.cardio
                          ? l10n.workoutRecordTemplateCardioDescription
                          : l10n.workoutRecordTemplateStrengthDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          l10n.workoutRecordAdd,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: iconColor,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward, size: 18, color: iconColor),
                      ],
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

  String _templateLabel(AppLocalizations l10n, String exerciseKey) {
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

class _WorkoutTemplate {
  const _WorkoutTemplate({
    required this.key,
    required this.icon,
    required this.cardio,
  });

  final String key;
  final IconData icon;
  final bool cardio;
}
