import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/profile/infra/entity/workout_record_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/workout_record_provider.dart';

class WorkoutRecordEntryView extends HookConsumerWidget {
  const WorkoutRecordEntryView({
    super.key,
    required this.exerciseKey,
    this.initialRecord,
  });

  static const String _distanceUnit = 'm';
  static const String _weightUnit = 'kg';

  final String exerciseKey;
  final WorkoutRecordEntity? initialRecord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final firstValueController = useTextEditingController();
    final secondValueController = useTextEditingController();
    final selectedDate = useState(initialRecord?.recordedAt ?? DateTime.now());
    final selectedPresetKey = useState<String?>(initialRecord?.presetKey);
    final didInitializeForm = useState(false);
    final isEditing = initialRecord != null;

    final exercisesState = ref.watch(workoutExercisesProvider);
    final presetsState = ref.watch(workoutExercisePresetsProvider);
    final controllerState = ref.watch(workoutRecordControllerProvider);
    final isSubmitting = controllerState.isLoading;

    final exercise = _findExercise(exercisesState.asData?.value, exerciseKey);
    final isCardio =
        exercise?.isCardio ?? _isCardioExerciseFallback(exerciseKey);
    final presets = _presetsForExercise(
      presetsState.asData?.value,
      exerciseKey,
    );

    useEffect(
      () {
        if (presets.isEmpty || didInitializeForm.value) {
          return null;
        }

        if (!_hasPreset(presets, selectedPresetKey.value)) {
          selectedPresetKey.value = presets.first.presetKey;
        }

        if (initialRecord != null) {
          if (initialRecord!.isTimeRecord) {
            secondValueController.text = _formatDurationMmSs(
              initialRecord!.recordSeconds,
            );
          } else {
            firstValueController.text = _formatWeight(
              initialRecord!.recordWeightKg,
            );
          }
        }

        didInitializeForm.value = true;
        return null;
      },
      [
        didInitializeForm.value,
        initialRecord,
        presets,
        selectedPresetKey.value,
      ],
    );

    final selectedPreset = _findPreset(presets, selectedPresetKey.value);
    final minimalEnabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );
    final minimalFocusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.outline, width: 1.2),
    );
    final minimalErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.error),
    );
    final minimalFocusedErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colorScheme.error, width: 1.2),
    );

    useEffect(
      () {
        if (!didInitializeForm.value) {
          return null;
        }

        if (isCardio) {
          final distance = selectedPreset?.distanceM;
          firstValueController.text = distance == null
              ? ''
              : distance.toString();
        } else {
          secondValueController.text =
              selectedPreset?.targetReps?.toString() ?? '';
        }

        return null;
      },
      [
        didInitializeForm.value,
        isCardio,
        selectedPreset?.distanceM,
        selectedPreset?.presetKey,
        selectedPreset?.targetReps,
      ],
    );

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
        title: Text(
          isEditing
              ? l10n.workoutRecordEditDialogTitle
              : l10n.workoutRecordEntryTitle(_exerciseLabel(l10n, exerciseKey)),
        ),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(
              AppRoutes.workoutRecordLeaderboardName,
              pathParameters: {'exercise': exerciseKey},
            ),
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: l10n.workoutRecordViewLeaderboard,
          ),
          IconButton(
            onPressed: () => context.pushNamed(
              AppRoutes.workoutRecordListName,
              pathParameters: {'exercise': exerciseKey},
            ),
            icon: const Icon(Icons.list_alt_outlined),
            tooltip: l10n.workoutRecordViewRecords,
          ),
        ],
      ),
      body: SafeArea(
        child: presetsState.when(
          data: (_) => Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                DropdownButtonFormField<String>(
                  key: ValueKey('preset-${selectedPresetKey.value ?? 'none'}'),
                  initialValue: selectedPresetKey.value,
                  decoration: InputDecoration(
                    labelText: l10n.workoutRecordPreset,
                    filled: false,
                    enabledBorder: minimalEnabledBorder,
                    focusedBorder: minimalFocusedBorder,
                    errorBorder: minimalErrorBorder,
                    focusedErrorBorder: minimalFocusedErrorBorder,
                  ),
                  items: presets
                      .map(
                        (preset) => DropdownMenuItem<String>(
                          value: preset.presetKey,
                          child: Text(_presetLabel(preset.presetKey)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: isSubmitting
                      ? null
                      : (value) {
                          selectedPresetKey.value = value;
                        },
                  validator: (value) =>
                      value == null ? l10n.workoutRecordInvalidNumber : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: firstValueController,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: !isCardio,
                  ),
                  decoration: InputDecoration(
                    labelText: isCardio
                        ? l10n.workoutRecordDistance
                        : l10n.workoutRecordWeight,
                    suffixText: isCardio ? _distanceUnit : _weightUnit,
                    filled: false,
                    enabledBorder: minimalEnabledBorder,
                    focusedBorder: minimalFocusedBorder,
                    errorBorder: minimalErrorBorder,
                    focusedErrorBorder: minimalFocusedErrorBorder,
                  ),
                  readOnly: isCardio,
                  onTap: isCardio
                      ? null
                      : () {
                          FocusScope.of(context).requestFocus();
                        },
                  validator: (value) {
                    if (isCardio) {
                      if (selectedPreset?.distanceM == null ||
                          selectedPreset!.distanceM! <= 0) {
                        return l10n.workoutRecordInvalidNumber;
                      }
                      return null;
                    }

                    final weight = double.tryParse((value ?? '').trim());
                    if (weight == null || weight <= 0) {
                      return l10n.workoutRecordInvalidNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: secondValueController,
                  keyboardType: isCardio
                      ? TextInputType.datetime
                      : TextInputType.number,
                  readOnly: !isCardio,
                  decoration: InputDecoration(
                    labelText: isCardio
                        ? l10n.workoutRecordDuration
                        : l10n.workoutRecordReps,
                    hintText: isCardio ? '18:55' : null,
                    filled: false,
                    enabledBorder: minimalEnabledBorder,
                    focusedBorder: minimalFocusedBorder,
                    errorBorder: minimalErrorBorder,
                    focusedErrorBorder: minimalFocusedErrorBorder,
                  ),
                  validator: (value) {
                    if (isCardio) {
                      final seconds = _parseDurationMmSs(value);
                      if (seconds == null) {
                        return l10n.workoutRecordInvalidDurationFormat;
                      }
                      return null;
                    }

                    if (selectedPreset?.targetReps == null ||
                        selectedPreset!.targetReps! <= 0) {
                      return l10n.workoutRecordInvalidNumber;
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
                      locale.languageCode,
                    ).format(selectedDate.value),
                  ),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: isSubmitting
                      ? null
                      : () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate.value,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (picked == null || !context.mounted) {
                            return;
                          }
                          selectedDate.value = picked;
                        },
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: isSubmitting
                      ? null
                      : () => _submit(
                          context: context,
                          ref: ref,
                          formKey: formKey,
                          firstValueController: firstValueController,
                          secondValueController: secondValueController,
                          recordedAt: selectedDate.value,
                          exerciseKey: exerciseKey,
                          initialRecord: initialRecord,
                          recordType:
                              exercise?.recordType ??
                              (isCardio
                                  ? WorkoutRecordType.time
                                  : WorkoutRecordType.weight),
                          selectedPreset: selectedPreset,
                        ),
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    isSubmitting ? l10n.profileSaving : l10n.workoutRecordSave,
                  ),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text(l10n.workoutRecordLoadFailed)),
        ),
      ),
    );
  }

  Future<void> _submit({
    required BuildContext context,
    required WidgetRef ref,
    required GlobalKey<FormState> formKey,
    required TextEditingController firstValueController,
    required TextEditingController secondValueController,
    required DateTime recordedAt,
    required String exerciseKey,
    required WorkoutRecordEntity? initialRecord,
    required WorkoutRecordType recordType,
    required WorkoutExercisePresetEntity? selectedPreset,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final isCardio = recordType == WorkoutRecordType.time;
    if (formKey.currentState?.validate() != true) {
      return;
    }

    if (selectedPreset == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.workoutRecordSaveFailed)));
      return;
    }

    final firstRaw = firstValueController.text.trim();
    final secondValue = isCardio
        ? _parseDurationMmSs(secondValueController.text.trim())
        : selectedPreset.targetReps;
    if (secondValue == null) {
      return;
    }

    final distance = isCardio ? selectedPreset.distanceM : null;
    final weight = isCardio ? null : double.tryParse(firstRaw);

    if (isCardio && (distance == null || distance <= 0)) {
      return;
    }

    if (!isCardio && (weight == null || weight <= 0)) {
      return;
    }

    final controller = ref.read(workoutRecordControllerProvider.notifier);
    if (initialRecord == null) {
      await controller.createRecord(
        exerciseName: exerciseKey,
        recordType: recordType,
        distance: distance,
        recordSeconds: isCardio ? secondValue : null,
        recordWeightKg: weight,
        recordReps: isCardio ? null : secondValue,
        recordedAt: recordedAt,
        memo: '',
        presetKey: selectedPreset.presetKey,
      );
    } else {
      await controller.updateRecord(
        id: initialRecord.id,
        exerciseName: exerciseKey,
        recordType: recordType,
        distance: distance,
        recordSeconds: isCardio ? secondValue : null,
        recordWeightKg: weight,
        recordReps: isCardio ? null : secondValue,
        recordedAt: recordedAt,
        memo: initialRecord.memo,
        presetKey: selectedPreset.presetKey,
      );
    }

    if (!context.mounted) {
      return;
    }

    final nextState = ref.read(workoutRecordControllerProvider);
    if (nextState.hasError) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.workoutRecordSaved)));
    Navigator.of(context).pop();
  }

  static int? _parseDurationMmSs(String? input) {
    final raw = (input ?? '').trim();
    if (raw.isEmpty) {
      return null;
    }

    final match = RegExp(r'^(\d+):([0-5]\d)$').firstMatch(raw);
    if (match == null) {
      return null;
    }

    final minutes = int.parse(match.group(1)!);
    final seconds = int.parse(match.group(2)!);
    final totalSeconds = (minutes * 60) + seconds;
    if (totalSeconds <= 0) {
      return null;
    }

    return totalSeconds;
  }

  static String _formatDurationMmSs(int? valueSeconds) {
    if (valueSeconds == null || valueSeconds <= 0) {
      return '';
    }

    final minutes = valueSeconds ~/ 60;
    final seconds = valueSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  static String _formatWeight(double? value) {
    if (value == null || value <= 0) {
      return '';
    }

    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  WorkoutExerciseEntity? _findExercise(
    List<WorkoutExerciseEntity>? exercises,
    String targetKey,
  ) {
    if (exercises == null) {
      return null;
    }
    for (final exercise in exercises) {
      if (exercise.exerciseKey == targetKey) {
        return exercise;
      }
    }
    return null;
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

  WorkoutExercisePresetEntity? _findPreset(
    List<WorkoutExercisePresetEntity> presets,
    String? presetKey,
  ) {
    if (presetKey == null) {
      return null;
    }
    for (final preset in presets) {
      if (preset.presetKey == presetKey) {
        return preset;
      }
    }
    return null;
  }

  bool _hasPreset(
    List<WorkoutExercisePresetEntity> presets,
    String? presetKey,
  ) {
    if (presetKey == null) {
      return false;
    }

    for (final preset in presets) {
      if (preset.presetKey == presetKey) {
        return true;
      }
    }

    return false;
  }

  bool _isCardioExerciseFallback(String key) {
    switch (key) {
      case 'rowing':
      case 'running':
      case 'ski':
        return true;
      default:
        return false;
    }
  }

  String _presetLabel(String presetKey) {
    final lower = presetKey.toLowerCase();
    if (lower.endsWith('rm')) {
      return lower.toUpperCase();
    }
    return presetKey;
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
