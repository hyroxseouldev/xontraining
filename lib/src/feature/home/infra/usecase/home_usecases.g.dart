// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_usecases.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getProgramsByTenantUseCase)
final getProgramsByTenantUseCaseProvider =
    GetProgramsByTenantUseCaseProvider._();

final class GetProgramsByTenantUseCaseProvider
    extends
        $FunctionalProvider<
          GetProgramsByTenantUseCase,
          GetProgramsByTenantUseCase,
          GetProgramsByTenantUseCase
        >
    with $Provider<GetProgramsByTenantUseCase> {
  GetProgramsByTenantUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getProgramsByTenantUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getProgramsByTenantUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetProgramsByTenantUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetProgramsByTenantUseCase create(Ref ref) {
    return getProgramsByTenantUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetProgramsByTenantUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetProgramsByTenantUseCase>(value),
    );
  }
}

String _$getProgramsByTenantUseCaseHash() =>
    r'56c4833522abf1938ef3122bebbde48da2b36407';
