// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tenantId)
final tenantIdProvider = TenantIdProvider._();

final class TenantIdProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  TenantIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tenantIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tenantIdHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return tenantId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$tenantIdHash() => r'f26acf65ce7054835bb8cd2ce69e6078759cdeb7';
