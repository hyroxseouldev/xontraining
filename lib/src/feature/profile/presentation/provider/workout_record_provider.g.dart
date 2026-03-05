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
    r'36a2f02b611623905314bd04a4dd10bf8d8af759';

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
