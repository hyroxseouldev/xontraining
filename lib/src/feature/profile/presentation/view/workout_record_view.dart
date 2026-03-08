import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/workout_record_provider.dart';
import 'package:xontraining/src/shared/layout_breakpoints.dart';

class WorkoutRecordView extends ConsumerWidget {
  const WorkoutRecordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = LayoutBreakpoints.isTablet(context);
    final exercisesState = ref.watch(workoutExercisesProvider);

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
      body: exercisesState.when(
        data: (exercises) {
          final activeExercises = exercises
              .where((exercise) => exercise.isActive)
              .toList(growable: false);

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 6 : 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isTablet ? 0.95 : 0.9,
            ),
            itemCount: activeExercises.length,
            itemBuilder: (context, index) {
              final exercise = activeExercises[index];

              return Card(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => context.pushNamed(
                    AppRoutes.workoutRecordEntryName,
                    pathParameters: {'exercise': exercise.exerciseKey},
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          _exerciseIcon(exercise.exerciseKey),
                          size: isTablet ? 34 : 30,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _exerciseLabel(l10n, exercise.exerciseKey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.workoutRecordLoadFailed)),
      ),
    );
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
