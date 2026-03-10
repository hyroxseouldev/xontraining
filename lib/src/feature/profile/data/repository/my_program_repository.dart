import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/profile/data/datasource/my_program_data_source.dart';
import 'package:xontraining/src/feature/profile/infra/entity/my_program_entity.dart';

abstract interface class MyProgramRepository {
  Future<MyProgramPageEntity> getMyProgramsPage({
    required String tenantId,
    required String userId,
    required MyProgramStatus status,
    required int limit,
    required int offset,
  });
}

class MyProgramRepositoryImpl implements MyProgramRepository {
  MyProgramRepositoryImpl({required this.dataSource});

  final MyProgramDataSource dataSource;

  @override
  Future<MyProgramPageEntity> getMyProgramsPage({
    required String tenantId,
    required String userId,
    required MyProgramStatus status,
    required int limit,
    required int offset,
  }) async {
    try {
      final activeProgramId = await dataSource.getActiveProgramId(
        tenantId: tenantId,
        userId: userId,
      );
      final rows = await dataSource.getAccessibleProgramEntitlements(
        tenantId: tenantId,
        userId: userId,
      );
      final itemsByProgramId = <String, MyProgramItemEntity>{};

      for (final row in rows) {
        final item = _mapItem(row);
        if (item == null) {
          continue;
        }
        itemsByProgramId.putIfAbsent(item.program.id, () => item);
      }

      final items = itemsByProgramId.values.toList(growable: false);

      final filtered = switch (status) {
        MyProgramStatus.active =>
          activeProgramId == null
              ? const <MyProgramItemEntity>[]
              : items
                    .where((item) => item.program.id == activeProgramId)
                    .toList(growable: false),
        MyProgramStatus.inactive =>
          items
              .where((item) => item.program.id != activeProgramId)
              .toList(growable: false),
      };

      final totalCount = filtered.length;
      final paged = filtered.skip(offset).take(limit).toList(growable: false);
      final nextOffset = offset + paged.length;

      return MyProgramPageEntity(
        items: paged,
        totalCount: totalCount,
        nextOffset: nextOffset,
        hasMore: nextOffset < totalCount,
      );
    } on AuthException catch (error, stackTrace) {
      debugPrint('[MyProgramRepository] auth failure: $error');
      debugPrint('[MyProgramRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[MyProgramRepository] unexpected failure: $error');
      debugPrint('[MyProgramRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load my programs.',
        cause: error,
      );
    }
  }

  MyProgramItemEntity? _mapItem(Map<String, dynamic> raw) {
    final programRaw = raw['programs'];
    if (programRaw is! Map<String, dynamic>) {
      return null;
    }

    final id = programRaw['id'];
    final title = programRaw['title'];
    if (id is! String || title is! String) {
      return null;
    }

    return MyProgramItemEntity(
      program: ProgramEntity(
        id: id,
        title: title,
        description: programRaw['description'] as String?,
        thumbnailUrl: programRaw['thumbnail_url'] as String?,
        difficulty: programRaw['difficulty'] as String?,
        dailyWorkoutMinutes: _asInt(programRaw['daily_workout_minutes']),
        daysPerWeek: _asInt(programRaw['days_per_week']),
        startDate: _asDate(programRaw['start_date']),
        endDate: _asDate(programRaw['end_date']),
      ),
      activationStartAt: _asDate(raw['starts_at']),
      activationEndAt: _asDate(raw['ends_at']),
    );
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

final myProgramRepositoryProvider = Provider<MyProgramRepository>((ref) {
  return MyProgramRepositoryImpl(
    dataSource: ref.read(myProgramDataSourceProvider),
  );
});
