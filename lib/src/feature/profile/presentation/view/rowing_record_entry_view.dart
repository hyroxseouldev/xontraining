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
  const WorkoutRecordEntryView({super.key, required this.exerciseKey});

  static const String _distanceUnit = 'm';
  static const String _weightUnit = 'kg';

  final String exerciseKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isCardio = _isCardioExercise(exerciseKey);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final firstValueController = useTextEditingController();
    final secondValueController = useTextEditingController();
    final selectedDate = useState(DateTime.now());

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

    final controllerState = ref.watch(workoutRecordControllerProvider);
    final isSubmitting = controllerState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.workoutRecordEntryTitle(_exerciseLabel(l10n, exerciseKey)),
        ),
        actions: [
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
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
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
                ),
                validator: (value) {
                  if (isCardio) {
                    final distance = int.tryParse((value ?? '').trim());
                    if (distance == null || distance <= 0) {
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
                decoration: InputDecoration(
                  labelText: isCardio
                      ? l10n.workoutRecordDuration
                      : l10n.workoutRecordReps,
                  hintText: isCardio ? '18:55' : null,
                ),
                validator: (value) {
                  if (isCardio) {
                    final seconds = _parseDurationMmSs(value);
                    if (seconds == null) {
                      return l10n.workoutRecordInvalidDurationFormat;
                    }
                    return null;
                  }

                  final reps = int.tryParse((value ?? '').trim());
                  if (reps == null || reps <= 0) {
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
                      ),
                icon: const Icon(Icons.save_outlined),
                label: Text(
                  isSubmitting ? l10n.profileSaving : l10n.workoutRecordSave,
                ),
              ),
            ],
          ),
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
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final isCardio = _isCardioExercise(exerciseKey);
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final firstRaw = firstValueController.text.trim();
    final secondValue = isCardio
        ? _parseDurationMmSs(secondValueController.text.trim())
        : int.tryParse(secondValueController.text.trim());
    if (secondValue == null) {
      return;
    }

    final distance = isCardio ? int.tryParse(firstRaw) : null;
    final weight = isCardio ? null : double.parse(firstRaw);

    if (isCardio && distance == null) {
      return;
    }

    await ref
        .read(workoutRecordControllerProvider.notifier)
        .createRecord(
          exerciseName: exerciseKey,
          recordType: isCardio
              ? WorkoutRecordType.time
              : WorkoutRecordType.weight,
          distance: distance,
          recordSeconds: isCardio ? secondValue : null,
          recordWeightKg: weight,
          recordReps: isCardio ? null : secondValue,
          recordedAt: recordedAt,
          memo: '',
        );

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

  bool _isCardioExercise(String exerciseKey) {
    switch (exerciseKey) {
      case 'rowing':
      case 'running':
      case 'ski':
        return true;
      default:
        return false;
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
