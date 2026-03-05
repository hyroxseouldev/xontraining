// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_usecases.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getNoticesPageUseCase)
final getNoticesPageUseCaseProvider = GetNoticesPageUseCaseProvider._();

final class GetNoticesPageUseCaseProvider
    extends
        $FunctionalProvider<
          GetNoticesPageUseCase,
          GetNoticesPageUseCase,
          GetNoticesPageUseCase
        >
    with $Provider<GetNoticesPageUseCase> {
  GetNoticesPageUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getNoticesPageUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getNoticesPageUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetNoticesPageUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetNoticesPageUseCase create(Ref ref) {
    return getNoticesPageUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetNoticesPageUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetNoticesPageUseCase>(value),
    );
  }
}

String _$getNoticesPageUseCaseHash() =>
    r'550a1ccd847533333af234167bc4201d2b053f11';

@ProviderFor(getNoticeByIdUseCase)
final getNoticeByIdUseCaseProvider = GetNoticeByIdUseCaseProvider._();

final class GetNoticeByIdUseCaseProvider
    extends
        $FunctionalProvider<
          GetNoticeByIdUseCase,
          GetNoticeByIdUseCase,
          GetNoticeByIdUseCase
        >
    with $Provider<GetNoticeByIdUseCase> {
  GetNoticeByIdUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getNoticeByIdUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getNoticeByIdUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetNoticeByIdUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetNoticeByIdUseCase create(Ref ref) {
    return getNoticeByIdUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetNoticeByIdUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetNoticeByIdUseCase>(value),
    );
  }
}

String _$getNoticeByIdUseCaseHash() =>
    r'01f40c47ad42e0fdb76bece97b0ebc34d2f37076';
