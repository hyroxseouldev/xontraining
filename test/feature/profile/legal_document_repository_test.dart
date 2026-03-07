import 'package:flutter_test/flutter_test.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/profile/data/datasource/legal_document_data_source.dart';
import 'package:xontraining/src/feature/profile/data/repository/legal_document_repository.dart';
import 'package:xontraining/src/feature/profile/infra/entity/legal_document_entity.dart';
import 'package:xontraining/src/feature/profile/infra/service/legal_html_parser.dart';

class _FakeLegalDocumentDataSource implements LegalDocumentDataSource {
  _FakeLegalDocumentDataSource(this._row);

  final Map<String, dynamic>? _row;

  @override
  Future<Map<String, dynamic>?> getPublishedDocument({
    required String tenantId,
    required String type,
    required String locale,
  }) async {
    return _row;
  }
}

void main() {
  group('LegalDocumentRepository', () {
    test('maps published document fields from data source', () async {
      final repository = LegalDocumentRepositoryImpl(
        dataSource: _FakeLegalDocumentDataSource({
          'type': 'terms_of_service',
          'locale': 'ko',
          'title': '이용약관',
          'content_html': '<h1>제목</h1><p>본문</p>',
          'version': 'v1.0.0',
          'updated_at': '2026-03-06T15:36:33.343975Z',
          'published_at': null,
        }),
        parser: LegalHtmlParser(),
      );

      final document = await repository.getPublishedDocument(
        tenantId: 'tenant-id',
        type: LegalDocumentType.termsOfService,
        locale: 'ko',
      );

      expect(document, isNotNull);
      expect(document!.type, LegalDocumentType.termsOfService);
      expect(document.locale, 'ko');
      expect(document.title, '이용약관');
      expect(document.version, 'v1.0.0');
      expect(document.contentJson, isNotEmpty);
    });

    test('uses published_at when updated_at is missing', () async {
      final repository = LegalDocumentRepositoryImpl(
        dataSource: _FakeLegalDocumentDataSource({
          'type': 'privacy_policy',
          'locale': 'ko',
          'title': '개인정보처리방침',
          'content_html': '<p>본문</p>',
          'version': 'v1.0.1',
          'updated_at': null,
          'published_at': '2026-03-07T12:00:00.000000Z',
        }),
        parser: LegalHtmlParser(),
      );

      final document = await repository.getPublishedDocument(
        tenantId: 'tenant-id',
        type: LegalDocumentType.privacyPolicy,
        locale: 'ko',
      );

      expect(document, isNotNull);
      expect(
        document!.updatedAt.toUtc(),
        DateTime.parse('2026-03-07T12:00:00Z'),
      );
    });

    test('throws AppException for invalid date values', () async {
      final repository = LegalDocumentRepositoryImpl(
        dataSource: _FakeLegalDocumentDataSource({
          'type': 'privacy_policy',
          'locale': 'ko',
          'title': '개인정보처리방침',
          'content_html': '<p>본문</p>',
          'version': 'v1.0.1',
          'updated_at': 'not-a-date',
          'published_at': null,
        }),
        parser: LegalHtmlParser(),
      );

      await expectLater(
        repository.getPublishedDocument(
          tenantId: 'tenant-id',
          type: LegalDocumentType.privacyPolicy,
          locale: 'ko',
        ),
        throwsA(isA<AppException>()),
      );
    });
  });
}
