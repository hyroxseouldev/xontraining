import 'dart:ui' show PlatformDispatcher;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/profile/infra/entity/legal_document_entity.dart';
import 'package:xontraining/src/feature/profile/infra/usecase/legal_document_usecases.dart';

part 'legal_document_provider.g.dart';

@riverpod
Future<LegalDocumentEntity> termsDocument(Ref ref) async {
  return _loadDocumentWithFallback(
    ref: ref,
    type: LegalDocumentType.termsOfService,
  );
}

@riverpod
Future<LegalDocumentEntity> privacyPolicyDocument(Ref ref) async {
  return _loadDocumentWithFallback(
    ref: ref,
    type: LegalDocumentType.privacyPolicy,
  );
}

Future<LegalDocumentEntity> _loadDocumentWithFallback({
  required Ref ref,
  required LegalDocumentType type,
}) async {
  final tenantId = ref.read(tenantIdProvider);
  final localeCode = PlatformDispatcher.instance.locale.languageCode;
  final useCase = ref.read(getLegalDocumentUseCaseProvider);

  final preferredDoc = await useCase(
    tenantId: tenantId,
    type: type,
    locale: localeCode,
  );
  if (preferredDoc != null) {
    return preferredDoc;
  }

  if (localeCode != 'ko') {
    final koreanDoc = await useCase(
      tenantId: tenantId,
      type: type,
      locale: 'ko',
    );
    if (koreanDoc != null) {
      return koreanDoc;
    }
  }

  throw const AppException.unknown(
    message: 'Published legal document not found.',
  );
}
