import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/workout_record_provider.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class WorkoutRecordView extends HookConsumerWidget {
  const WorkoutRecordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryController = useTextEditingController();
    final query = useState('');
    final sort = useState(_WorkoutSort.newest);

    useEffect(() {
      void listener() {
        query.value = queryController.text.trim().toLowerCase();
      }

      queryController.addListener(listener);
      return () => queryController.removeListener(listener);
    }, [queryController]);

    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final recordsState = ref.watch(workoutRecordsProvider);
    final controllerState = ref.watch(workoutRecordControllerProvider);
    final isBusy = controllerState.isLoading;

    ref.listen<AsyncValue<void>>(workoutRecordControllerProvider, (
      previous,
      next,
    ) {
      if ((previous?.isLoading ?? false) && next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.workoutRecordSaveFailed)));
      }
    });

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isBusy
            ? null
            : () => _showRecordDialog(context: context, ref: ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.workoutRecordAdd),
      ),
      body: recordsState.when(
        data: (records) {
          if (records.isEmpty) {
            return EmptyState(
              icon: Icons.fitness_center,
              message: l10n.workoutRecordEmpty,
            );
          }

          final visibleRecords = _applyFilterAndSort(
            records,
            query: query.value,
            sort: sort.value,
          );
          if (visibleRecords.isEmpty) {
            return EmptyState(
              icon: Icons.search_off,
              message: l10n.workoutRecordNoSearchResult,
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(workoutRecordsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: visibleRecords.length + 1,
              separatorBuilder: (context, index) => index == 0
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: queryController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: l10n.workoutRecordSearchHint,
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<_WorkoutSort>(
                          value: sort.value,
                          onChanged: (nextSort) {
                            if (nextSort == null) {
                              return;
                            }
                            sort.value = nextSort;
                          },
                          items: [
                            DropdownMenuItem<_WorkoutSort>(
                              value: _WorkoutSort.newest,
                              child: Text(l10n.workoutRecordSortNewest),
                            ),
                            DropdownMenuItem<_WorkoutSort>(
                              value: _WorkoutSort.oldest,
                              child: Text(l10n.workoutRecordSortOldest),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                final record = visibleRecords[index - 1];
                final visual = _metricVisual(context, record.metricType);
                return Card(
                  child: ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: visual.color.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(visual.icon, color: visual.color, size: 20),
                    ),
                    title: Text(record.exerciseName),
                    subtitle: Text(
                      '${_metricLabel(l10n, record.metricType)} · ${_valueLabel(record)}\n'
                      '${DateFormat.yMMMd(locale.languageCode).format(record.recordedAt)}',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<_WorkoutMenuAction>(
                      enabled: !isBusy,
                      onSelected: (action) async {
                        if (action == _WorkoutMenuAction.edit) {
                          await _showRecordDialog(
                            context: context,
                            ref: ref,
                            existing: record,
                          );
                          return;
                        }

                        await _deleteRecord(
                          context: context,
                          ref: ref,
                          record: record,
                        );
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<_WorkoutMenuAction>(
                            value: _WorkoutMenuAction.edit,
                            child: Text(l10n.workoutRecordEdit),
                          ),
                          PopupMenuItem<_WorkoutMenuAction>(
                            value: _WorkoutMenuAction.delete,
                            child: Text(l10n.workoutRecordDelete),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(child: Text(l10n.workoutRecordLoadFailed));
        },
      ),
    );
  }

  static List<WorkoutRecordEntity> _applyFilterAndSort(
    List<WorkoutRecordEntity> records, {
    required String query,
    required _WorkoutSort sort,
  }) {
    final filtered = records
        .where((record) {
          if (query.isEmpty) {
            return true;
          }

          final name = record.exerciseName.toLowerCase();
          final memo = record.memo.toLowerCase();
          return name.contains(query) || memo.contains(query);
        })
        .toList(growable: false);

    final sorted = [...filtered];
    sorted.sort((a, b) {
      final compareDate = a.recordedAt.compareTo(b.recordedAt);
      if (compareDate != 0) {
        return sort == _WorkoutSort.newest ? -compareDate : compareDate;
      }

      return sort == _WorkoutSort.newest
          ? b.exerciseName.compareTo(a.exerciseName)
          : a.exerciseName.compareTo(b.exerciseName);
    });

    return sorted;
  }

  static String _metricLabel(
    AppLocalizations l10n,
    WorkoutRecordMetricType metricType,
  ) {
    switch (metricType) {
      case WorkoutRecordMetricType.weight:
        return l10n.workoutRecordMetricWeight;
      case WorkoutRecordMetricType.reps:
        return l10n.workoutRecordMetricReps;
      case WorkoutRecordMetricType.distance:
        return l10n.workoutRecordMetricDistance;
      case WorkoutRecordMetricType.duration:
        return l10n.workoutRecordMetricDuration;
    }
  }

  static String _valueLabel(WorkoutRecordEntity record) {
    if (record.usesDuration) {
      final seconds = record.valueSeconds ?? 0;
      final minutes = seconds ~/ 60;
      final remain = seconds % 60;
      final padded = remain.toString().padLeft(2, '0');
      return '$minutes:$padded ${record.unit}';
    }

    final numeric = record.valueNumeric ?? 0;
    final numericLabel = numeric % 1 == 0
        ? numeric.toInt().toString()
        : numeric.toStringAsFixed(2);
    return '$numericLabel ${record.unit}';
  }

  static Future<void> _showRecordDialog({
    required BuildContext context,
    required WidgetRef ref,
    WorkoutRecordEntity? existing,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<_WorkoutRecordFormResult>(
      context: context,
      builder: (dialogContext) {
        return _WorkoutRecordDialog(existing: existing);
      },
    );

    if (result == null || !context.mounted) {
      return;
    }

    final rawValue = result.rawValue;
    final valueSeconds = result.metricType == WorkoutRecordMetricType.duration
        ? int.tryParse(rawValue)
        : null;
    final valueNumeric = result.metricType == WorkoutRecordMetricType.duration
        ? null
        : double.tryParse(rawValue);

    final controller = ref.read(workoutRecordControllerProvider.notifier);
    if (existing == null) {
      await controller.createRecord(
        exerciseName: result.exerciseName,
        metricType: result.metricType,
        valueNumeric: valueNumeric,
        valueSeconds: valueSeconds,
        unit: result.unit,
        recordedAt: result.recordedAt,
        memo: result.memo,
      );
    } else {
      await controller.updateRecord(
        id: existing.id,
        exerciseName: result.exerciseName,
        metricType: result.metricType,
        valueNumeric: valueNumeric,
        valueSeconds: valueSeconds,
        unit: result.unit,
        recordedAt: result.recordedAt,
        memo: result.memo,
      );
    }

    if (!context.mounted) {
      return;
    }

    final nextState = ref.read(workoutRecordControllerProvider);
    if (!nextState.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workoutRecordSaved)));
    }
  }

  static Future<void> _deleteRecord({
    required BuildContext context,
    required WidgetRef ref,
    required WorkoutRecordEntity record,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.workoutRecordDeleteDialogTitle),
          content: Text(l10n.workoutRecordDeleteDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.workoutRecordCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
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
        .deleteRecord(id: record.id);

    if (!context.mounted) {
      return;
    }

    final nextState = ref.read(workoutRecordControllerProvider);
    if (nextState.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workoutRecordDeleteFailed)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.workoutRecordDeleted)));
  }

  static String _defaultUnit(WorkoutRecordMetricType metricType) {
    switch (metricType) {
      case WorkoutRecordMetricType.weight:
        return 'kg';
      case WorkoutRecordMetricType.reps:
        return 'reps';
      case WorkoutRecordMetricType.distance:
        return 'km';
      case WorkoutRecordMetricType.duration:
        return 'sec';
    }
  }

  static _MetricVisual _metricVisual(
    BuildContext context,
    WorkoutRecordMetricType metricType,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (metricType) {
      case WorkoutRecordMetricType.weight:
        return _MetricVisual(Icons.fitness_center, colorScheme.tertiary);
      case WorkoutRecordMetricType.reps:
        return _MetricVisual(Icons.repeat, colorScheme.secondary);
      case WorkoutRecordMetricType.distance:
        return _MetricVisual(Icons.route, colorScheme.primary);
      case WorkoutRecordMetricType.duration:
        return _MetricVisual(Icons.timer_outlined, colorScheme.error);
    }
  }
}

class _WorkoutRecordDialog extends HookWidget {
  const _WorkoutRecordDialog({this.existing});

  final WorkoutRecordEntity? existing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final initialMetricType =
        existing?.metricType ?? WorkoutRecordMetricType.weight;
    final initialUseDefaultUnit =
        existing == null ||
        existing!.unit.trim().toLowerCase() ==
            WorkoutRecordView._defaultUnit(
              initialMetricType,
            ).trim().toLowerCase();

    final exerciseController = useTextEditingController(
      text: existing?.exerciseName ?? '',
    );
    final memoController = useTextEditingController(text: existing?.memo ?? '');
    final valueController = useTextEditingController(
      text: existing?.usesDuration == true
          ? (existing?.valueSeconds ?? 0).toString()
          : (existing?.valueNumeric?.toString() ?? ''),
    );
    final unitController = useTextEditingController(
      text: existing?.unit ?? WorkoutRecordView._defaultUnit(initialMetricType),
    );
    final metricType = useState(initialMetricType);
    final selectedDate = useState(existing?.recordedAt ?? DateTime.now());
    final useDefaultUnit = useState(initialUseDefaultUnit);

    useEffect(() {
      if (useDefaultUnit.value) {
        unitController.text = WorkoutRecordView._defaultUnit(metricType.value);
      }
      return null;
    }, [useDefaultUnit.value, metricType.value, unitController]);

    return AlertDialog(
      title: Text(
        existing == null
            ? l10n.workoutRecordAddDialogTitle
            : l10n.workoutRecordEditDialogTitle,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: exerciseController,
                decoration: InputDecoration(
                  labelText: l10n.workoutRecordExerciseName,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.workoutRecordRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<WorkoutRecordMetricType>(
                initialValue: metricType.value,
                decoration: InputDecoration(
                  labelText: l10n.workoutRecordMetricType,
                ),
                items: WorkoutRecordMetricType.values
                    .map((type) {
                      return DropdownMenuItem<WorkoutRecordMetricType>(
                        value: type,
                        child: Text(WorkoutRecordView._metricLabel(l10n, type)),
                      );
                    })
                    .toList(growable: false),
                onChanged: (nextType) {
                  if (nextType == null) {
                    return;
                  }

                  metricType.value = nextType;
                  valueController.clear();
                },
              ),
              const SizedBox(height: 6),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: useDefaultUnit.value,
                title: Text(l10n.workoutRecordUseDefaultUnit),
                subtitle: Text(l10n.workoutRecordUseDefaultUnitSubtitle),
                onChanged: (value) {
                  useDefaultUnit.value = value;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: valueController,
                keyboardType:
                    metricType.value == WorkoutRecordMetricType.duration
                    ? TextInputType.number
                    : const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText:
                      metricType.value == WorkoutRecordMetricType.duration
                      ? l10n.workoutRecordValueSeconds
                      : l10n.workoutRecordValue,
                ),
                validator: (value) {
                  final raw = value?.trim() ?? '';
                  if (raw.isEmpty) {
                    return l10n.workoutRecordRequired;
                  }
                  if (metricType.value == WorkoutRecordMetricType.duration) {
                    final seconds = int.tryParse(raw);
                    if (seconds == null || seconds <= 0) {
                      return l10n.workoutRecordInvalidNumber;
                    }
                    return null;
                  }
                  final numeric = double.tryParse(raw);
                  if (numeric == null || numeric <= 0) {
                    return l10n.workoutRecordInvalidNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: unitController,
                enabled: !useDefaultUnit.value,
                decoration: InputDecoration(labelText: l10n.workoutRecordUnit),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.workoutRecordRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.workoutRecordDate),
                subtitle: Text(
                  DateFormat.yMMMd(
                    Localizations.localeOf(context).languageCode,
                  ).format(selectedDate.value),
                ),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (picked == null || !context.mounted) {
                    return;
                  }

                  selectedDate.value = picked;
                },
              ),
              TextFormField(
                controller: memoController,
                decoration: InputDecoration(labelText: l10n.workoutRecordMemo),
                minLines: 2,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.workoutRecordCancel),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState?.validate() != true) {
              return;
            }
            Navigator.of(context).pop(
              _WorkoutRecordFormResult(
                exerciseName: exerciseController.text.trim(),
                metricType: metricType.value,
                rawValue: valueController.text.trim(),
                unit: unitController.text.trim(),
                recordedAt: selectedDate.value,
                memo: memoController.text.trim(),
              ),
            );
          },
          child: Text(l10n.workoutRecordSave),
        ),
      ],
    );
  }
}

class _WorkoutRecordFormResult {
  const _WorkoutRecordFormResult({
    required this.exerciseName,
    required this.metricType,
    required this.rawValue,
    required this.unit,
    required this.recordedAt,
    required this.memo,
  });

  final String exerciseName;
  final WorkoutRecordMetricType metricType;
  final String rawValue;
  final String unit;
  final DateTime recordedAt;
  final String memo;
}

enum _WorkoutMenuAction { edit, delete }

enum _WorkoutSort { newest, oldest }

class _MetricVisual {
  const _MetricVisual(this.icon, this.color);

  final IconData icon;
  final Color color;
}
