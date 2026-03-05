// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_document_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(termsDocument)
final termsDocumentProvider = TermsDocumentProvider._();

final class TermsDocumentProvider
    extends
        $FunctionalProvider<
          AsyncValue<LegalDocumentEntity>,
          LegalDocumentEntity,
          FutureOr<LegalDocumentEntity>
        >
    with
        $FutureModifier<LegalDocumentEntity>,
        $FutureProvider<LegalDocumentEntity> {
  TermsDocumentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'termsDocumentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$termsDocumentHash();

  @$internal
  @override
  $FutureProviderElement<LegalDocumentEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LegalDocumentEntity> create(Ref ref) {
    return termsDocument(ref);
  }
}

String _$termsDocumentHash() => r'6401f727a5e6ba893e5f88d0f924afa5f2883782';

@ProviderFor(privacyPolicyDocument)
final privacyPolicyDocumentProvider = PrivacyPolicyDocumentProvider._();

final class PrivacyPolicyDocumentProvider
    extends
        $FunctionalProvider<
          AsyncValue<LegalDocumentEntity>,
          LegalDocumentEntity,
          FutureOr<LegalDocumentEntity>
        >
    with
        $FutureModifier<LegalDocumentEntity>,
        $FutureProvider<LegalDocumentEntity> {
  PrivacyPolicyDocumentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyPolicyDocumentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyPolicyDocumentHash();

  @$internal
  @override
  $FutureProviderElement<LegalDocumentEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LegalDocumentEntity> create(Ref ref) {
    return privacyPolicyDocument(ref);
  }
}

String _$privacyPolicyDocumentHash() =>
    r'7b6e1827dcf459a5b24ff5a20f65ecc44c77a480';
