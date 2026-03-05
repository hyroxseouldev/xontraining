import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';
import 'package:xontraining/src/feature/home/data/datasource/home_data_source.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';

part 'home_repository.g.dart';

abstract interface class HomeRepository {
  Future<ActiveProgramEntity?> getCurrentActiveProgram();
  Future<List<BlueprintSectionEntity>> getBlueprintSectionsByDate({
    required String programId,
    required DateTime date,
  });
}

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.dataSource});

  final HomeDataSource dataSource;

  @override
  Future<ActiveProgramEntity?> getCurrentActiveProgram() async {
    try {
      debugPrint('[HomeRepository] getCurrentActiveProgram started');
      final raw = await dataSource.getCurrentActiveProgram();
      if (raw == null) {
        debugPrint('[HomeRepository] getCurrentActiveProgram empty');
        return null;
      }

      final id = raw['id'];
      final title = raw['title'];
      if (id is! String || title is! String) {
        throw const FormatException('Invalid active program payload.');
      }

      final entity = ActiveProgramEntity(
        id: id,
        title: title,
        thumbnailUrl: raw['logo_url'] as String?,
        shortDescription: null,
        description: raw['description'] as String?,
      );
      debugPrint('[HomeRepository] getCurrentActiveProgram success');
      return entity;
    } on AuthException catch (error, stackTrace) {
      debugPrint('[HomeRepository] activeProgram auth failure: $error');
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[HomeRepository] activeProgram unexpected failure: $error');
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load active program.',
        cause: error,
      );
    }
  }

  @override
  Future<List<BlueprintSectionEntity>> getBlueprintSectionsByDate({
    required String programId,
    required DateTime date,
  }) async {
    try {
      debugPrint('[HomeRepository] getBlueprintSectionsByDate started');
      final rawItems = await dataSource.getBlueprintSectionsByDate(
        programId: programId,
        date: date,
      );

      final sections = <BlueprintSectionEntity>[];
      for (var index = 0; index < rawItems.length; index++) {
        final item = rawItems[index];
        final id = item['id'];
        final title = item['title'];
        if (id is! String || title is! String) {
          continue;
        }

        sections.add(
          BlueprintSectionEntity(
            id: id,
            title: title,
            content: (item['content_html'] as String?) ?? '',
            orderIndex: index,
          ),
        );
      }
      debugPrint('[HomeRepository] getBlueprintSectionsByDate success');
      return sections;
    } on AuthException catch (error, stackTrace) {
      debugPrint('[HomeRepository] schedule auth failure: $error');
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.auth(message: error.message, cause: error);
    } catch (error, stackTrace) {
      debugPrint('[HomeRepository] schedule unexpected failure: $error');
      debugPrint('[HomeRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load schedule.',
        cause: error,
      );
    }
  }
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepositoryImpl(dataSource: ref.read(homeDataSourceProvider));
}
