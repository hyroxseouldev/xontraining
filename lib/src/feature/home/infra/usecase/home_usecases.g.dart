// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_usecases.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getCurrentActiveProgramUseCase)
final getCurrentActiveProgramUseCaseProvider =
    GetCurrentActiveProgramUseCaseProvider._();

final class GetCurrentActiveProgramUseCaseProvider
    extends
        $FunctionalProvider<
          GetCurrentActiveProgramUseCase,
          GetCurrentActiveProgramUseCase,
          GetCurrentActiveProgramUseCase
        >
    with $Provider<GetCurrentActiveProgramUseCase> {
  GetCurrentActiveProgramUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentActiveProgramUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentActiveProgramUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCurrentActiveProgramUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCurrentActiveProgramUseCase create(Ref ref) {
    return getCurrentActiveProgramUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCurrentActiveProgramUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCurrentActiveProgramUseCase>(
        value,
      ),
    );
  }
}

String _$getCurrentActiveProgramUseCaseHash() =>
    r'1c94f9d076309f92d80a248dd0afad946f0ea444';

@ProviderFor(getBlueprintSectionsUseCase)
final getBlueprintSectionsUseCaseProvider =
    GetBlueprintSectionsUseCaseProvider._();

final class GetBlueprintSectionsUseCaseProvider
    extends
        $FunctionalProvider<
          GetBlueprintSectionsUseCase,
          GetBlueprintSectionsUseCase,
          GetBlueprintSectionsUseCase
        >
    with $Provider<GetBlueprintSectionsUseCase> {
  GetBlueprintSectionsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getBlueprintSectionsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getBlueprintSectionsUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetBlueprintSectionsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetBlueprintSectionsUseCase create(Ref ref) {
    return getBlueprintSectionsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetBlueprintSectionsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetBlueprintSectionsUseCase>(value),
    );
  }
}

String _$getBlueprintSectionsUseCaseHash() =>
    r'16af2763c198483beaedb5c8dc0636c5fd49f652';
