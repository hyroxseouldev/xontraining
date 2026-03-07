import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/feature/profile/data/repository/legal_document_repository.dart';
import 'package:xontraining/src/feature/profile/infra/entity/legal_document_entity.dart';

class GetLegalDocumentUseCase {
  GetLegalDocumentUseCase({required this.repository});

  final LegalDocumentRepository repository;

  Future<LegalDocumentEntity?> call({
    required String tenantId,
    required LegalDocumentType type,
    required String locale,
  }) {
    return repository.getPublishedDocument(
      tenantId: tenantId,
      type: type,
      locale: locale,
    );
  }
}

final getLegalDocumentUseCaseProvider = Provider<GetLegalDocumentUseCase>((
  ref,
) {
  return GetLegalDocumentUseCase(
    repository: ref.read(legalDocumentRepositoryProvider),
  );
});
