import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/home/data/datasource/home_data_source.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';

part 'home_repository.g.dart';

abstract interface class HomeRepository {
  Future<List<ProgramEntity>> getProgramsByTenant({required String tenantId});
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
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepositoryImpl(dataSource: ref.read(homeDataSourceProvider));
}
