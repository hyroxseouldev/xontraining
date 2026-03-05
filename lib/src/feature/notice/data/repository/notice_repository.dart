import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/notice/data/datasource/notice_data_source.dart';
import 'package:xontraining/src/feature/notice/infra/entity/notice_entity.dart';

part 'notice_repository.g.dart';

abstract interface class NoticeRepository {
  Future<List<NoticeEntity>> getNoticesPage({
    required String tenantId,
    required int limit,
    required int offset,
  });

  Future<NoticeEntity> getNoticeById({
    required String tenantId,
    required String noticeId,
  });
}

class NoticeRepositoryImpl implements NoticeRepository {
  NoticeRepositoryImpl({required this.dataSource});

  final NoticeDataSource dataSource;

  @override
  Future<List<NoticeEntity>> getNoticesPage({
    required String tenantId,
    required int limit,
    required int offset,
  }) async {
    try {
      final rows = await dataSource.getNoticesPage(
        tenantId: tenantId,
        limit: limit,
        offset: offset,
      );
      final items = <NoticeEntity>[];

      for (final row in rows) {
        final mapped = _mapRowToEntity(row);
        if (mapped != null) {
          items.add(mapped);
        }
      }

      return items;
    } on AuthException catch (error, stackTrace) {
      debugPrint('[NoticeRepository] getNoticesPage auth failure: $error');
      debugPrint('[NoticeRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[NoticeRepository] getNoticesPage unexpected failure: $error',
      );
      debugPrint('[NoticeRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load notices.',
        cause: error,
      );
    }
  }

  @override
  Future<NoticeEntity> getNoticeById({
    required String tenantId,
    required String noticeId,
  }) async {
    try {
      final row = await dataSource.getNoticeById(
        tenantId: tenantId,
        noticeId: noticeId,
      );
      if (row == null) {
        throw const AppException.unknown(message: 'Notice not found.');
      }

      final mapped = _mapRowToEntity(row);
      if (mapped == null) {
        throw const AppException.unknown(message: 'Notice has invalid schema.');
      }

      return mapped;
    } on AuthException catch (error, stackTrace) {
      debugPrint('[NoticeRepository] getNoticeById auth failure: $error');
      debugPrint('[NoticeRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('[NoticeRepository] getNoticeById unexpected failure: $error');
      debugPrint('[NoticeRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load notice.',
        cause: error,
      );
    }
  }

  NoticeEntity? _mapRowToEntity(Map<String, dynamic> row) {
    final id = row['id'];
    final title = row['title'];
    final contentHtml = row['content_html'];
    final thumbnailUrl = row['thumbnail_url'];
    final createdAtRaw = row['created_at'];

    if (id is! String ||
        title is! String ||
        contentHtml is! String ||
        thumbnailUrl is! String ||
        createdAtRaw is! String) {
      return null;
    }

    final createdAt = DateTime.tryParse(createdAtRaw);
    if (createdAt == null) {
      return null;
    }

    return NoticeEntity(
      id: id,
      title: title,
      contentHtml: contentHtml,
      thumbnailUrl: thumbnailUrl,
      createdAt: createdAt,
    );
  }
}

@riverpod
NoticeRepository noticeRepository(Ref ref) {
  return NoticeRepositoryImpl(dataSource: ref.read(noticeDataSourceProvider));
}
