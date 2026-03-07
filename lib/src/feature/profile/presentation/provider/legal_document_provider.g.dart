// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_document_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(legalDocument)
final legalDocumentProvider = LegalDocumentFamily._();

final class LegalDocumentProvider
    extends
        $FunctionalProvider<
          AsyncValue<LegalDocumentEntity>,
          LegalDocumentEntity,
          FutureOr<LegalDocumentEntity>
        >
    with
        $FutureModifier<LegalDocumentEntity>,
        $FutureProvider<LegalDocumentEntity> {
  LegalDocumentProvider._({
    required LegalDocumentFamily super.from,
    required ({LegalDocumentType type, String localeCode}) super.argument,
  }) : super(
         retry: null,
         name: r'legalDocumentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$legalDocumentHash();

  @override
  String toString() {
    return r'legalDocumentProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<LegalDocumentEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LegalDocumentEntity> create(Ref ref) {
    final argument =
        this.argument as ({LegalDocumentType type, String localeCode});
    return legalDocument(
      ref,
      type: argument.type,
      localeCode: argument.localeCode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LegalDocumentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$legalDocumentHash() => r'41eecc088e63a77e8bead0c06808e521be699abf';

final class LegalDocumentFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<LegalDocumentEntity>,
          ({LegalDocumentType type, String localeCode})
        > {
  LegalDocumentFamily._()
    : super(
        retry: null,
        name: r'legalDocumentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LegalDocumentProvider call({
    required LegalDocumentType type,
    required String localeCode,
  }) => LegalDocumentProvider._(
    argument: (type: type, localeCode: localeCode),
    from: this,
  );

  @override
  String toString() => r'legalDocumentProvider';
}
