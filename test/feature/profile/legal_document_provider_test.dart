import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/profile/data/repository/legal_document_repository.dart';
import 'package:xontraining/src/feature/profile/infra/entity/legal_document_entity.dart';
import 'package:xontraining/src/feature/profile/infra/usecase/legal_document_usecases.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/legal_document_provider.dart';

class _FakeLegalDocumentRepository implements LegalDocumentRepository {
  final requests =
      <({String tenantId, LegalDocumentType type, String locale})>[];

  @override
  Future<LegalDocumentEntity?> getPublishedDocument({
    required String tenantId,
    required LegalDocumentType type,
    required String locale,
  }) async {
    requests.add((tenantId: tenantId, type: type, locale: locale));

    if (type == LegalDocumentType.termsOfService && locale == 'ko') {
      return _buildDocument(type: type, locale: 'ko', title: '이용약관');
    }
    if (type == LegalDocumentType.privacyPolicy && locale == 'ko') {
      return _buildDocument(type: type, locale: 'ko', title: '개인정보처리방침');
    }

    return null;
  }

  LegalDocumentEntity _buildDocument({
    required LegalDocumentType type,
    required String locale,
    required String title,
  }) {
    return LegalDocumentEntity(
      type: type,
      locale: locale,
      title: title,
      version: 'v1.0.0',
      updatedAt: DateTime.utc(2026, 3, 7),
      rawHtml: '<p>content</p>',
      contentJson: const [
        {
          'type': 'paragraph',
          'children': [
            {'type': 'text', 'text': 'content'},
          ],
        },
      ],
    );
  }
}

void main() {
  group('legalDocumentProvider', () {
    test('falls back to korean document when locale is unavailable', () async {
      final fakeRepository = _FakeLegalDocumentRepository();
      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWith((ref) => 'tenant-id'),
          getLegalDocumentUseCaseProvider.overrideWith(
            (ref) => GetLegalDocumentUseCase(repository: fakeRepository),
          ),
        ],
      );
      addTearDown(container.dispose);

      final document = await container.read(
        legalDocumentProvider(
          type: LegalDocumentType.termsOfService,
          localeCode: 'en',
        ).future,
      );

      expect(document.locale, 'ko');
      expect(fakeRepository.requests.map((request) => request.locale), [
        'en',
        'ko',
      ]);
    });

    test('does not fallback when locale is already korean', () async {
      final fakeRepository = _FakeLegalDocumentRepository();
      final container = ProviderContainer(
        overrides: [
          tenantIdProvider.overrideWith((ref) => 'tenant-id'),
          getLegalDocumentUseCaseProvider.overrideWith(
            (ref) => GetLegalDocumentUseCase(repository: fakeRepository),
          ),
        ],
      );
      addTearDown(container.dispose);

      final document = await container.read(
        legalDocumentProvider(
          type: LegalDocumentType.privacyPolicy,
          localeCode: 'ko',
        ).future,
      );

      expect(document.locale, 'ko');
      expect(fakeRepository.requests.map((request) => request.locale), ['ko']);
    });
  });
}
