// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_record_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutRecords)
final workoutRecordsProvider = WorkoutRecordsProvider._();

final class WorkoutRecordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutRecordEntity>>,
          List<WorkoutRecordEntity>,
          FutureOr<List<WorkoutRecordEntity>>
        >
    with
        $FutureModifier<List<WorkoutRecordEntity>>,
        $FutureProvider<List<WorkoutRecordEntity>> {
  WorkoutRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutRecordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutRecordsHash();

  @$internal
  @override
  $FutureProviderElement<List<WorkoutRecordEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WorkoutRecordEntity>> create(Ref ref) {
    return workoutRecords(ref);
  }
}

String _$workoutRecordsHash() => r'a0d0dcac260b5e4588de3382676167f03864b2ff';

@ProviderFor(workoutExercises)
final workoutExercisesProvider = WorkoutExercisesProvider._();

final class WorkoutExercisesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutExerciseEntity>>,
          List<WorkoutExerciseEntity>,
          FutureOr<List<WorkoutExerciseEntity>>
        >
    with
        $FutureModifier<List<WorkoutExerciseEntity>>,
        $FutureProvider<List<WorkoutExerciseEntity>> {
  WorkoutExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutExercisesHash();

  @$internal
  @override
  $FutureProviderElement<List<WorkoutExerciseEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WorkoutExerciseEntity>> create(Ref ref) {
    return workoutExercises(ref);
  }
}

String _$workoutExercisesHash() => r'5c989ef6c50be15ef926c5325e4e225af942c07b';

@ProviderFor(workoutExercisePresets)
final workoutExercisePresetsProvider = WorkoutExercisePresetsProvider._();

final class WorkoutExercisePresetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkoutExercisePresetEntity>>,
          List<WorkoutExercisePresetEntity>,
          FutureOr<List<WorkoutExercisePresetEntity>>
        >
    with
        $FutureModifier<List<WorkoutExercisePresetEntity>>,
        $FutureProvider<List<WorkoutExercisePresetEntity>> {
  WorkoutExercisePresetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutExercisePresetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutExercisePresetsHash();

  @$internal
  @override
  $FutureProviderElement<List<WorkoutExercisePresetEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WorkoutExercisePresetEntity>> create(Ref ref) {
    return workoutExercisePresets(ref);
  }
}

String _$workoutExercisePresetsHash() =>
    r'adb1407b7025f61a62bb025d5fa9af60c32a5dc2';

@ProviderFor(WorkoutRecordController)
final workoutRecordControllerProvider = WorkoutRecordControllerProvider._();

final class WorkoutRecordControllerProvider
    extends $NotifierProvider<WorkoutRecordController, AsyncValue<void>> {
  WorkoutRecordControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutRecordControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutRecordControllerHash();

  @$internal
  @override
  WorkoutRecordController create() => WorkoutRecordController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$workoutRecordControllerHash() =>
    r'd90bf9d5882d07b586d6b02ed9297bcb9d725089';

abstract class _$WorkoutRecordController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
