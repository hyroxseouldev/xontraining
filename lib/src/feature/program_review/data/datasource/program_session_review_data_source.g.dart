// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_session_review_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(programSessionReviewDataSource)
final programSessionReviewDataSourceProvider =
    ProgramSessionReviewDataSourceProvider._();

final class ProgramSessionReviewDataSourceProvider
    extends
        $FunctionalProvider<
          ProgramSessionReviewDataSource,
          ProgramSessionReviewDataSource,
          ProgramSessionReviewDataSource
        >
    with $Provider<ProgramSessionReviewDataSource> {
  ProgramSessionReviewDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'programSessionReviewDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$programSessionReviewDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProgramSessionReviewDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProgramSessionReviewDataSource create(Ref ref) {
    return programSessionReviewDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgramSessionReviewDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgramSessionReviewDataSource>(
        value,
      ),
    );
  }
}

String _$programSessionReviewDataSourceHash() =>
    r'173ab91fabdcc9e2c4718512f054ca2dc4be57e9';
