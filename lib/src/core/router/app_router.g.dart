// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_routerRefresh)
final _routerRefreshProvider = _RouterRefreshProvider._();

final class _RouterRefreshProvider
    extends
        $FunctionalProvider<
          GoRouterRefreshStream,
          GoRouterRefreshStream,
          GoRouterRefreshStream
        >
    with $Provider<GoRouterRefreshStream> {
  _RouterRefreshProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'_routerRefreshProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$_routerRefreshHash();

  @$internal
  @override
  $ProviderElement<GoRouterRefreshStream> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoRouterRefreshStream create(Ref ref) {
    return _routerRefresh(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouterRefreshStream value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouterRefreshStream>(value),
    );
  }
}

String _$_routerRefreshHash() => r'b854b890f2bc1cba98f4548f9e46df66e1c22c83';

@ProviderFor(goRouter)
final goRouterProvider = GoRouterProvider._();

final class GoRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  GoRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return goRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$goRouterHash() => r'1e91bf8d0fdc4b47200b6fd742a1d8cfb9090545';
