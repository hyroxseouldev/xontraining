import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/workout_record_provider.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class WorkoutRecordView extends ConsumerStatefulWidget {
  const WorkoutRecordView({super.key});

  @override
  ConsumerState<WorkoutRecordView> createState() => _WorkoutRecordViewState();
}

class _WorkoutRecordViewState extends ConsumerState<WorkoutRecordView> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';
  _WorkoutSort _sort = _WorkoutSort.newest;

  @override
  void initState() {
    super.initState();
    _queryController.addListener(() {
      setState(() {
        _query = _queryController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

          final visibleRecords = _applyFilterAndSort(records);
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
                            controller: _queryController,
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
                          value: _sort,
                          onChanged: (nextSort) {
                            if (nextSort == null) {
                              return;
                            }
                            setState(() {
                              _sort = nextSort;
                            });
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

  List<WorkoutRecordEntity> _applyFilterAndSort(
    List<WorkoutRecordEntity> records,
  ) {
    final filtered = records
        .where((record) {
          if (_query.isEmpty) {
            return true;
          }

          final name = record.exerciseName.toLowerCase();
          final memo = record.memo.toLowerCase();
          return name.contains(_query) || memo.contains(_query);
        })
        .toList(growable: false);

    final sorted = [...filtered];
    sorted.sort((a, b) {
      final compareDate = a.recordedAt.compareTo(b.recordedAt);
      if (compareDate != 0) {
        return _sort == _WorkoutSort.newest ? -compareDate : compareDate;
      }

      return _sort == _WorkoutSort.newest
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
    final formKey = GlobalKey<FormState>();
    final exerciseController = TextEditingController(
      text: existing?.exerciseName ?? '',
    );
    final memoController = TextEditingController(text: existing?.memo ?? '');

    var metricType = existing?.metricType ?? WorkoutRecordMetricType.weight;
    var valueController = TextEditingController(
      text: existing?.usesDuration == true
          ? (existing?.valueSeconds ?? 0).toString()
          : (existing?.valueNumeric?.toString() ?? ''),
    );
    var unitController = TextEditingController(
      text: existing?.unit ?? _defaultUnit(metricType),
    );
    var selectedDate = existing?.recordedAt ?? DateTime.now();
    var useDefaultUnit =
        existing == null ||
        existing.unit.trim().toLowerCase() ==
            _defaultUnit(metricType).trim().toLowerCase();

    if (useDefaultUnit) {
      unitController.text = _defaultUnit(metricType);
    }

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                        initialValue: metricType,
                        decoration: InputDecoration(
                          labelText: l10n.workoutRecordMetricType,
                        ),
                        items: WorkoutRecordMetricType.values
                            .map((type) {
                              return DropdownMenuItem<WorkoutRecordMetricType>(
                                value: type,
                                child: Text(_metricLabel(l10n, type)),
                              );
                            })
                            .toList(growable: false),
                        onChanged: (nextType) {
                          if (nextType == null) {
                            return;
                          }

                          setState(() {
                            metricType = nextType;
                            valueController.dispose();
                            valueController = TextEditingController();
                            if (useDefaultUnit) {
                              unitController.text = _defaultUnit(nextType);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 6),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        value: useDefaultUnit,
                        title: Text(l10n.workoutRecordUseDefaultUnit),
                        subtitle: Text(
                          l10n.workoutRecordUseDefaultUnitSubtitle,
                        ),
                        onChanged: (value) {
                          setState(() {
                            useDefaultUnit = value;
                            if (useDefaultUnit) {
                              unitController.text = _defaultUnit(metricType);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: valueController,
                        keyboardType:
                            metricType == WorkoutRecordMetricType.duration
                            ? TextInputType.number
                            : const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                        decoration: InputDecoration(
                          labelText:
                              metricType == WorkoutRecordMetricType.duration
                              ? l10n.workoutRecordValueSeconds
                              : l10n.workoutRecordValue,
                        ),
                        validator: (value) {
                          final raw = value?.trim() ?? '';
                          if (raw.isEmpty) {
                            return l10n.workoutRecordRequired;
                          }
                          if (metricType == WorkoutRecordMetricType.duration) {
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
                        enabled: !useDefaultUnit,
                        decoration: InputDecoration(
                          labelText: l10n.workoutRecordUnit,
                        ),
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
                          ).format(selectedDate),
                        ),
                        trailing: const Icon(Icons.calendar_today_outlined),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );

                          if (picked == null) {
                            return;
                          }

                          setState(() {
                            selectedDate = picked;
                          });
                        },
                      ),
                      TextFormField(
                        controller: memoController,
                        decoration: InputDecoration(
                          labelText: l10n.workoutRecordMemo,
                        ),
                        minLines: 2,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(l10n.workoutRecordCancel),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() != true) {
                      return;
                    }
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: Text(l10n.workoutRecordSave),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != true || !context.mounted) {
      exerciseController.dispose();
      valueController.dispose();
      unitController.dispose();
      memoController.dispose();
      return;
    }

    final rawValue = valueController.text.trim();
    final valueSeconds = metricType == WorkoutRecordMetricType.duration
        ? int.tryParse(rawValue)
        : null;
    final valueNumeric = metricType == WorkoutRecordMetricType.duration
        ? null
        : double.tryParse(rawValue);

    final controller = ref.read(workoutRecordControllerProvider.notifier);
    if (existing == null) {
      await controller.createRecord(
        exerciseName: exerciseController.text.trim(),
        metricType: metricType,
        valueNumeric: valueNumeric,
        valueSeconds: valueSeconds,
        unit: unitController.text.trim(),
        recordedAt: selectedDate,
        memo: memoController.text.trim(),
      );
    } else {
      await controller.updateRecord(
        id: existing.id,
        exerciseName: exerciseController.text.trim(),
        metricType: metricType,
        valueNumeric: valueNumeric,
        valueSeconds: valueSeconds,
        unit: unitController.text.trim(),
        recordedAt: selectedDate,
        memo: memoController.text.trim(),
      );
    }

    if (!context.mounted) {
      exerciseController.dispose();
      valueController.dispose();
      unitController.dispose();
      memoController.dispose();
      return;
    }

    final nextState = ref.read(workoutRecordControllerProvider);
    if (!nextState.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workoutRecordSaved)));
    }

    exerciseController.dispose();
    valueController.dispose();
    unitController.dispose();
    memoController.dispose();
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

enum _WorkoutMenuAction { edit, delete }

enum _WorkoutSort { newest, oldest }

class _MetricVisual {
  const _MetricVisual(this.icon, this.color);

  final IconData icon;
  final Color color;
}
