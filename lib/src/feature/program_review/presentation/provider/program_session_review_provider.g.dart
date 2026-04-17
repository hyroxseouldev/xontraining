// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_session_review_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myProgramSessionReviews)
final myProgramSessionReviewsProvider = MyProgramSessionReviewsFamily._();

final class MyProgramSessionReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, ProgramSessionReviewEntity>>,
          Map<String, ProgramSessionReviewEntity>,
          FutureOr<Map<String, ProgramSessionReviewEntity>>
        >
    with
        $FutureModifier<Map<String, ProgramSessionReviewEntity>>,
        $FutureProvider<Map<String, ProgramSessionReviewEntity>> {
  MyProgramSessionReviewsProvider._({
    required MyProgramSessionReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'myProgramSessionReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$myProgramSessionReviewsHash();

  @override
  String toString() {
    return r'myProgramSessionReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, ProgramSessionReviewEntity>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, ProgramSessionReviewEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return myProgramSessionReviews(ref, programId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MyProgramSessionReviewsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myProgramSessionReviewsHash() =>
    r'152e0bc3292fd939d574a3852b0f49d50ad79e53';

final class MyProgramSessionReviewsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, ProgramSessionReviewEntity>>,
          String
        > {
  MyProgramSessionReviewsFamily._()
    : super(
        retry: null,
        name: r'myProgramSessionReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MyProgramSessionReviewsProvider call({required String programId}) =>
      MyProgramSessionReviewsProvider._(argument: programId, from: this);

  @override
  String toString() => r'myProgramSessionReviewsProvider';
}

@ProviderFor(coachProgramSessionReviews)
final coachProgramSessionReviewsProvider = CoachProgramSessionReviewsFamily._();

final class CoachProgramSessionReviewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CoachProgramSessionReviewEntity>>,
          List<CoachProgramSessionReviewEntity>,
          FutureOr<List<CoachProgramSessionReviewEntity>>
        >
    with
        $FutureModifier<List<CoachProgramSessionReviewEntity>>,
        $FutureProvider<List<CoachProgramSessionReviewEntity>> {
  CoachProgramSessionReviewsProvider._({
    required CoachProgramSessionReviewsFamily super.from,
    required ProgramSessionReviewStatus? super.argument,
  }) : super(
         retry: null,
         name: r'coachProgramSessionReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$coachProgramSessionReviewsHash();

  @override
  String toString() {
    return r'coachProgramSessionReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CoachProgramSessionReviewEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CoachProgramSessionReviewEntity>> create(Ref ref) {
    final argument = this.argument as ProgramSessionReviewStatus?;
    return coachProgramSessionReviews(ref, status: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CoachProgramSessionReviewsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$coachProgramSessionReviewsHash() =>
    r'3721f3f015ee76897db8bafeac463ba07dab1de3';

final class CoachProgramSessionReviewsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<CoachProgramSessionReviewEntity>>,
          ProgramSessionReviewStatus?
        > {
  CoachProgramSessionReviewsFamily._()
    : super(
        retry: null,
        name: r'coachProgramSessionReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CoachProgramSessionReviewsProvider call({
    ProgramSessionReviewStatus? status,
  }) => CoachProgramSessionReviewsProvider._(argument: status, from: this);

  @override
  String toString() => r'coachProgramSessionReviewsProvider';
}

@ProviderFor(ProgramSessionReviewController)
final programSessionReviewControllerProvider =
    ProgramSessionReviewControllerProvider._();

final class ProgramSessionReviewControllerProvider
    extends
        $NotifierProvider<ProgramSessionReviewController, AsyncValue<void>> {
  ProgramSessionReviewControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programSessionReviewControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programSessionReviewControllerHash();

  @$internal
  @override
  ProgramSessionReviewController create() => ProgramSessionReviewController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$programSessionReviewControllerHash() =>
    r'1671fbaca937ff6c450ab48c4c98ce4433be5b0c';

abstract class _$ProgramSessionReviewController
    extends $Notifier<AsyncValue<void>> {
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
