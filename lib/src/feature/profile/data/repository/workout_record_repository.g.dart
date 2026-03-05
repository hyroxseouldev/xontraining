// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_record_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutRecordRepository)
final workoutRecordRepositoryProvider = WorkoutRecordRepositoryProvider._();

final class WorkoutRecordRepositoryProvider
    extends
        $FunctionalProvider<
          WorkoutRecordRepository,
          WorkoutRecordRepository,
          WorkoutRecordRepository
        >
    with $Provider<WorkoutRecordRepository> {
  WorkoutRecordRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutRecordRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutRecordRepositoryHash();

  @$internal
  @override
  $ProviderElement<WorkoutRecordRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WorkoutRecordRepository create(Ref ref) {
    return workoutRecordRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WorkoutRecordRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WorkoutRecordRepository>(value),
    );
  }
}

String _$workoutRecordRepositoryHash() =>
    r'6eeaa7d395b76f54c16cfb190807e6b8503d7f90';
