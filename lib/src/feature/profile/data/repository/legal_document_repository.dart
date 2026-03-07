import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/profile/data/datasource/legal_document_data_source.dart';
import 'package:xontraining/src/feature/profile/infra/entity/legal_document_entity.dart';
import 'package:xontraining/src/feature/profile/infra/service/legal_html_parser.dart';

abstract interface class LegalDocumentRepository {
  Future<LegalDocumentEntity?> getPublishedDocument({
    required String tenantId,
    required LegalDocumentType type,
    required String locale,
  });
}

class LegalDocumentRepositoryImpl implements LegalDocumentRepository {
  LegalDocumentRepositoryImpl({required this.dataSource, required this.parser});

  final LegalDocumentDataSource dataSource;
  final LegalHtmlParser parser;

  static const _typeByEntity = <LegalDocumentType, String>{
    LegalDocumentType.termsOfService: 'terms_of_service',
    LegalDocumentType.privacyPolicy: 'privacy_policy',
  };

  @override
  Future<LegalDocumentEntity?> getPublishedDocument({
    required String tenantId,
    required LegalDocumentType type,
    required String locale,
  }) async {
    try {
      final row = await dataSource.getPublishedDocument(
        tenantId: tenantId,
        type: _typeByEntity[type]!,
        locale: locale,
      );

      if (row == null) {
        return null;
      }

      final contentHtml = row['content_html'];
      final titleValue = row['title'];
      final localeValue = row['locale'];
      final version = row['version'];
      final updatedAtValue = row['updated_at'] ?? row['published_at'];

      if (contentHtml is! String ||
          titleValue is! String ||
          localeValue is! String ||
          version is! String ||
          updatedAtValue is! String && updatedAtValue is! DateTime) {
        throw const AppException.unknown(
          message: 'Failed to parse legal document.',
        );
      }

      final updatedAt = updatedAtValue is DateTime
          ? updatedAtValue
          : DateTime.tryParse(updatedAtValue);
      if (updatedAt == null) {
        throw const AppException.unknown(
          message: 'Failed to parse legal document date.',
        );
      }

      return LegalDocumentEntity(
        type: type,
        locale: localeValue,
        title: titleValue,
        version: version,
        updatedAt: updatedAt,
        rawHtml: contentHtml,
        contentJson: parser.parseToJson(contentHtml),
      );
    } on PostgrestException catch (error, stackTrace) {
      debugPrint(
        '[LegalDocumentRepository] getPublishedDocument postgrest failure: $error',
      );
      debugPrint('[LegalDocumentRepository] StackTrace: $stackTrace');
      throw AppException.unknown(message: error.message, cause: error);
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      debugPrint(
        '[LegalDocumentRepository] getPublishedDocument unexpected failure: $error',
      );
      debugPrint('[LegalDocumentRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load legal document.',
        cause: error,
      );
    }
  }
}

final legalDocumentRepositoryProvider = Provider<LegalDocumentRepository>((
  ref,
) {
  return LegalDocumentRepositoryImpl(
    dataSource: ref.read(legalDocumentDataSourceProvider),
    parser: LegalHtmlParser(),
  );
});
