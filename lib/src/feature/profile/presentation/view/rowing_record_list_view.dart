import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/workout_record_provider.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class WorkoutRecordListView extends ConsumerWidget {
  const WorkoutRecordListView({super.key, required this.exerciseKey});

  final String exerciseKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isCardio = _isCardioExercise(exerciseKey);
    final recordsState = ref.watch(workoutRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.workoutRecordListTitle(_exerciseLabel(l10n, exerciseKey)),
        ),
      ),
      body: recordsState.when(
        data: (records) {
          final rowingRecords = records
              .where(
                (record) =>
                    record.exerciseName.trim().toLowerCase() == exerciseKey,
              )
              .toList(growable: false);

          if (rowingRecords.isEmpty) {
            return EmptyState(
              icon: _exerciseIcon(exerciseKey),
              message: l10n.workoutRecordEmptyByExercise(
                _exerciseLabel(l10n, exerciseKey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(workoutRecordsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: rowingRecords.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final record = rowingRecords[index];
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _exerciseIcon(exerciseKey),
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      isCardio
                          ? l10n.workoutRecordDistanceAndDuration(
                              _distanceLabel(record),
                              _durationLabel(record.recordSeconds),
                            )
                          : l10n.workoutRecordStrengthWeightAndReps(
                              _weightLabel(record),
                              _repsLabel(record.recordReps),
                            ),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd(
                        locale.languageCode,
                      ).format(record.recordedAt),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text(l10n.workoutRecordLoadFailed)),
      ),
    );
  }

  String _distanceLabel(WorkoutRecordEntity record) {
    final value = record.distance;
    if (value == null || value <= 0) {
      return '0 m';
    }
    return '$value m';
  }

  String _weightLabel(WorkoutRecordEntity record) {
    final value = record.recordWeightKg ?? 0;
    if (value % 1 == 0) {
      return '${value.toInt()} kg';
    }
    return '${value.toStringAsFixed(2)} kg';
  }

  String _durationLabel(int? valueSeconds) {
    if (valueSeconds == null || valueSeconds <= 0) {
      return '0:00';
    }
    final minutes = valueSeconds ~/ 60;
    final seconds = valueSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _repsLabel(int? reps) {
    final value = reps ?? 0;
    return value.toString();
  }

  bool _isCardioExercise(String key) {
    switch (key) {
      case 'rowing':
      case 'running':
      case 'ski':
        return true;
      default:
        return false;
    }
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

  String _exerciseLabel(AppLocalizations l10n, String key) {
    switch (key) {
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
        return key;
    }
  }
}
