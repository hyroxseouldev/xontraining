// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_session_review_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(programSessionReviewRepository)
final programSessionReviewRepositoryProvider =
    ProgramSessionReviewRepositoryProvider._();

final class ProgramSessionReviewRepositoryProvider
    extends
        $FunctionalProvider<
          ProgramSessionReviewRepository,
          ProgramSessionReviewRepository,
          ProgramSessionReviewRepository
        >
    with $Provider<ProgramSessionReviewRepository> {
  ProgramSessionReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programSessionReviewRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programSessionReviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProgramSessionReviewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgramSessionReviewRepository create(Ref ref) {
    return programSessionReviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgramSessionReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgramSessionReviewRepository>(
        value,
      ),
    );
  }
}

String _$programSessionReviewRepositoryHash() =>
    r'2357757100273a1ca6f3be62d42a13be527f4428';
