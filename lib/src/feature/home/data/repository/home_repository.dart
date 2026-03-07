import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/home/data/datasource/home_data_source.dart';
import 'package:xontraining/src/feature/home/infra/entity/coach_info_entity.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/infra/entity/program_detail_entity.dart';

part 'home_repository.g.dart';

abstract interface class HomeRepository {
  Future<List<ProgramEntity>> getProgramsByTenant({required String tenantId});

  Future<bool> hasProgramAccess({
    required String tenantId,
    required String userId,
    required String programId,
  });

  Future<List<ProgramSessionEntity>> getSessionsByProgram({
    required String tenantId,
    required String programId,
  });

  Future<CoachInfoEntity?> getCoachInfoByTenant({required String tenantId});
}

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.dataSource});

  final HomeDataSource dataSource;

  @override
  Future<List<ProgramEntity>> getProgramsByTenant({
    required String tenantId,
  }) async {
    try {
      debugPrint(
        '[HomeRepository] getProgramsByTenant started tenantId=$tenantId',
      );
      final rawItems = await dataSource.getProgramsByTenant(tenantId: tenantId);
      debugPrint('[HomeRepository] fetched programs count=${rawItems.length}');
      if (rawItems.isEmpty) {
        debugPrint(
          '[HomeRepository] no programs returned for tenantId=$tenantId',
        );
      } else {
        debugPrint(
          '[HomeRepository] first row keys=${rawItems.first.keys.toList()}',
        );
      }
      final programs = <ProgramEntity>[];
      var skippedCount = 0;

      for (var index = 0; index < rawItems.length; index += 1) {
        final raw = rawItems[index];
        final id = raw['id'];
        final title = raw['title'];
        if (id is! String || title is! String) {
          skippedCount += 1;
          debugPrint(
            '[HomeRepository] skipped row index=$index '
            'idType=${id.runtimeType} titleType=${title.runtimeType}',
          );
          continue;
        }

        programs.add(
          ProgramEntity(
            id: id,
            title: title,
            description: raw['description'] as String?,
            thumbnailUrl: raw['thumbnail_url'] as String?,
            difficulty: raw['difficulty'] as String?,
            dailyWorkoutMinutes: _asInt(raw['daily_workout_minutes']),
            daysPerWeek: _asInt(raw['days_per_week']),
            startDate: _asDate(raw['start_date']),
            endDate: _asDate(raw['end_date']),
          ),
        );
      }

      if (skippedCount > 0) {
        debugPrint(
          '[HomeRepository] skipped invalid program rows=$skippedCount',
        );
      }
      debugPrint(
        '[HomeRepository] getProgramsByTenant success mapped=${programs.length}',
      );
      return programs;
    } on AuthException catch (error, stackTrace) {
      debugPrint(
        '[HomeRepository] getProgramsByTenant auth failure tenantId=$tenantId: $error',
      );
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[HomeRepository] getProgramsByTenant unexpected failure tenantId=$tenantId: $error',
      );
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load programs.',
        cause: error,
      );
    }
  }

  int? _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  DateTime? _asDate(Object? value) {
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  @override
  Future<bool> hasProgramAccess({
    required String tenantId,
    required String userId,
    required String programId,
  }) async {
    try {
      return await dataSource.hasProgramAccess(
        tenantId: tenantId,
        userId: userId,
        programId: programId,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint('[HomeRepository] hasProgramAccess auth failure: $error');
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[HomeRepository] hasProgramAccess unexpected failure: $error',
      );
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to check program access.',
        cause: error,
      );
    }
  }

  @override
  Future<List<ProgramSessionEntity>> getSessionsByProgram({
    required String tenantId,
    required String programId,
  }) async {
    try {
      final rawItems = await dataSource.getSessionsByProgram(
        tenantId: tenantId,
        programId: programId,
      );
      final sessions = <ProgramSessionEntity>[];

      for (final raw in rawItems) {
        final id = raw['id'];
        final dateRaw = raw['session_date'];
        final title = raw['title'];
        final contentHtml = raw['content_html'];
        final isPublishedRaw = raw['is_published'];
        final publishAtRaw = raw['publish_at'];
        final sessionTypeRaw = raw['session_type'];
        if (id is! String ||
            title is! String ||
            contentHtml is! String ||
            dateRaw is! String ||
            isPublishedRaw is! bool) {
          continue;
        }

        final parsedDate = DateTime.tryParse(dateRaw);
        if (parsedDate == null) {
          continue;
        }

        final parsedPublishAt = _asDateTime(publishAtRaw);
        final parsedSessionType = _asSessionType(sessionTypeRaw);

        sessions.add(
          ProgramSessionEntity(
            id: id,
            sessionDate: _dateOnly(parsedDate),
            title: title,
            contentHtml: contentHtml,
            isPublished: isPublishedRaw,
            publishAt: parsedPublishAt,
            sessionType: parsedSessionType,
          ),
        );
      }

      return sessions;
    } on AuthException catch (error, stackTrace) {
      debugPrint('[HomeRepository] getSessionsByProgram auth failure: $error');
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[HomeRepository] getSessionsByProgram unexpected failure: $error',
      );
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load sessions.',
        cause: error,
      );
    }
  }

  @override
  Future<CoachInfoEntity?> getCoachInfoByTenant({
    required String tenantId,
  }) async {
    try {
      final raw = await dataSource.getCoachInfoByTenant(tenantId: tenantId);
      if (raw == null) {
        return null;
      }

      final name = (raw['coach_name'] as String?)?.trim() ?? '';
      final instagram = (raw['coach_instagram'] as String?)?.trim() ?? '';
      final imageUrl = (raw['coach_image_url'] as String?)?.trim() ?? '';
      final career = _toStringList(raw['coach_career']);

      if (name.isEmpty &&
          instagram.isEmpty &&
          imageUrl.isEmpty &&
          career.isEmpty) {
        return null;
      }

      return CoachInfoEntity(
        imageUrl: imageUrl,
        name: name,
        career: career,
        instagram: instagram,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint('[HomeRepository] getCoachInfoByTenant auth failure: $error');
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint(
        '[HomeRepository] getCoachInfoByTenant unexpected failure: $error',
      );
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load coach info.',
        cause: error,
      );
    }
  }

  List<String> _toStringList(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  DateTime? _asDateTime(Object? value) {
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  ProgramSessionType _asSessionType(Object? value) {
    if (value is String && value == 'rest') {
      return ProgramSessionType.rest;
    }
    return ProgramSessionType.training;
  }
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepositoryImpl(dataSource: ref.read(homeDataSourceProvider));
}
