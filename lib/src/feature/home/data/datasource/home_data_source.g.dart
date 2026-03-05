// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeDataSource)
final homeDataSourceProvider = HomeDataSourceProvider._();

final class HomeDataSourceProvider
    extends $FunctionalProvider<HomeDataSource, HomeDataSource, HomeDataSource>
    with $Provider<HomeDataSource> {
  HomeDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDataSourceHash();

  @$internal
  @override
  $ProviderElement<HomeDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeDataSource create(Ref ref) {
    return homeDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeDataSource>(value),
    );
  }
}

String _$homeDataSourceHash() => r'a38bc5df4141368cb3cc933013f39cce5a4da80a';
