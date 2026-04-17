import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/workout_record_provider.dart';
import 'package:xontraining/src/feature/profile/presentation/widget/workout_record_loading_skeleton.dart';
import 'package:xontraining/src/shared/empty_state.dart';

enum _WorkoutRecordMenuAction { edit, delete }

class WorkoutRecordListView extends ConsumerWidget {
  const WorkoutRecordListView({super.key, required this.exerciseKey});

  final String exerciseKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final recordsState = ref.watch(workoutRecordsProvider);
    final controllerState = ref.watch(workoutRecordControllerProvider);
    final isSubmitting = controllerState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.workoutRecordListTitle(_exerciseLabel(l10n, exerciseKey)),
        ),
      ),
      body: recordsState.when(
        data: (records) {
          final exerciseRecords = records
              .where(
                (record) =>
                    record.exerciseName.trim().toLowerCase() == exerciseKey,
              )
              .toList(growable: false);

          if (exerciseRecords.isEmpty) {
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
              itemCount: exerciseRecords.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final record = exerciseRecords[index];
                return Card(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Icon(_exerciseIcon(exerciseKey), size: 20),
                    title: Text(
                      record.isTimeRecord
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
                      '${_presetLabel(record.presetKey)} · ${DateFormat.yMMMd(locale.languageCode).format(record.recordedAt)}',
                    ),
                    trailing: PopupMenuButton<_WorkoutRecordMenuAction>(
                      enabled: !isSubmitting,
                      onSelected: (value) async {
                        switch (value) {
                          case _WorkoutRecordMenuAction.edit:
                            await context.pushNamed(
                              AppRoutes.workoutRecordEntryName,
                              pathParameters: {'exercise': exerciseKey},
                              extra: record,
                            );
                            return;
                          case _WorkoutRecordMenuAction.delete:
                            await _deleteRecord(
                              context: context,
                              ref: ref,
                              recordId: record.id,
                            );
                            return;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<_WorkoutRecordMenuAction>(
                          value: _WorkoutRecordMenuAction.edit,
                          child: Text(l10n.workoutRecordEdit),
                        ),
                        PopupMenuItem<_WorkoutRecordMenuAction>(
                          value: _WorkoutRecordMenuAction.delete,
                          child: Text(l10n.workoutRecordDelete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const WorkoutRecordListLoadingSkeleton(),
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

  Future<void> _deleteRecord({
    required BuildContext context,
    required WidgetRef ref,
    required String recordId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.workoutRecordDeleteDialogTitle),
          content: Text(l10n.workoutRecordDeleteDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.workoutRecordCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.workoutRecordDelete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await ref
        .read(workoutRecordControllerProvider.notifier)
        .deleteRecord(id: recordId);

    if (!context.mounted) {
      return;
    }

    final nextState = ref.read(workoutRecordControllerProvider);
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          nextState.hasError
              ? l10n.workoutRecordDeleteFailed
              : l10n.workoutRecordDeleted,
        ),
      ),
    );
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

  String _presetLabel(String? presetKey) {
    if (presetKey == null || presetKey.isEmpty) {
      return '-';
    }
    final lower = presetKey.toLowerCase();
    if (lower.endsWith('rm')) {
      return lower.toUpperCase();
    }
    return presetKey;
  }
}
