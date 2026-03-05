import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/profile/data/mock/legal_document_mock_data.dart';
import 'package:xontraining/src/feature/profile/infra/entity/legal_document_entity.dart';

part 'legal_document_provider.g.dart';

@riverpod
Future<LegalDocumentEntity> termsDocument(Ref ref) async {
  return buildMockTermsOfService();
}

@riverpod
Future<LegalDocumentEntity> privacyPolicyDocument(Ref ref) async {
  return buildMockPrivacyPolicy();
}
