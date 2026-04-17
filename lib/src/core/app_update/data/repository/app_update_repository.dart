import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/core/app_update/data/datasource/app_update_data_source.dart';
import 'package:xontraining/src/core/app_update/infra/entity/app_update_policy_entity.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';

abstract interface class AppUpdateRepository {
  Future<AppUpdatePolicyEntity?> getActivePolicy({
    required AppUpdatePlatform platform,
  });
}

class AppUpdateRepositoryImpl implements AppUpdateRepository {
  AppUpdateRepositoryImpl({required this.dataSource});

  final AppUpdateDataSource dataSource;

  @override
  Future<AppUpdatePolicyEntity?> getActivePolicy({
    required AppUpdatePlatform platform,
  }) async {
    try {
      final row = await dataSource.getActivePolicy(platform: platform.value);
      if (row == null) {
        return null;
      }

      final platformValue = row['platform'];
      final minimumVersionValue = row['minimum_version'];
      final storeUrlValue = row['store_url'];
      final isActiveValue = row['is_active'];

      if (platformValue is! String ||
          minimumVersionValue is! String ||
          storeUrlValue is! String ||
          isActiveValue is! bool) {
        throw const AppException.unknown(
          message: 'Failed to parse app update policy.',
        );
      }

      final parsedPlatform = AppUpdatePlatform.fromValue(platformValue);
      final minimumVersion = minimumVersionValue.trim();
      final storeUrl = storeUrlValue.trim();
      if (parsedPlatform == null ||
          minimumVersion.isEmpty ||
          storeUrl.isEmpty) {
        throw const AppException.unknown(
          message: 'App update policy contains invalid values.',
        );
      }

      return AppUpdatePolicyEntity(
        platform: parsedPlatform,
        minimumVersion: minimumVersion,
        storeUrl: storeUrl,
        isActive: isActiveValue,
      );
    } on PostgrestException catch (error, stackTrace) {
      debugPrint('[AppUpdateRepository] postgrest failure: $error');
      debugPrint('[AppUpdateRepository] StackTrace: $stackTrace');
      throw AppException.unknown(message: error.message, cause: error);
    } on AppException {
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('[AppUpdateRepository] unexpected failure: $error');
      debugPrint('[AppUpdateRepository] StackTrace: $stackTrace');
      throw AppException.unknown(
        message: 'Failed to load app update policy.',
        cause: error,
      );
    }
  }
}

final appUpdateRepositoryProvider = Provider<AppUpdateRepository>((ref) {
  return AppUpdateRepositoryImpl(
    dataSource: ref.read(appUpdateDataSourceProvider),
  );
});
