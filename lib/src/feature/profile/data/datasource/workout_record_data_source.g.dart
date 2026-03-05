// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_record_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutRecordDataSource)
final workoutRecordDataSourceProvider = WorkoutRecordDataSourceProvider._();

final class WorkoutRecordDataSourceProvider
    extends
        $FunctionalProvider<
          WorkoutRecordDataSource,
          WorkoutRecordDataSource,
          WorkoutRecordDataSource
        >
    with $Provider<WorkoutRecordDataSource> {
  WorkoutRecordDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutRecordDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutRecordDataSourceHash();

  @$internal
  @override
  $ProviderElement<WorkoutRecordDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutRecordDataSource create(Ref ref) {
    return workoutRecordDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutRecordDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutRecordDataSource>(value),
    );
  }
}

String _$workoutRecordDataSourceHash() =>
    r'eccdceb164abbd917f84aca20b82078327ac0273';
