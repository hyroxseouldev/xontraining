import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/app_update/data/repository/app_update_repository.dart';
import 'package:xontraining/src/core/app_update/infra/entity/app_update_check_result.dart';
import 'package:xontraining/src/core/app_update/infra/entity/app_update_policy_entity.dart';
import 'package:xontraining/src/core/app_update/infra/service/app_metadata_service.dart';
import 'package:xontraining/src/core/app_update/infra/service/app_version_comparator.dart';

class CheckForceUpdateUseCase {
  CheckForceUpdateUseCase({
    required this.repository,
    required this.appMetadataService,
  });

  final AppUpdateRepository repository;
  final AppMetadataService appMetadataService;

  Future<AppUpdateCheckResult> call() async {
    try {
      final currentVersion = await appMetadataService.getAppVersion();
      if (!appMetadataService.isIos) {
        return AppUpdateCheckResult.noUpdate(currentVersion: currentVersion);
      }

      final policy = await repository.getActivePolicy(
        platform: AppUpdatePlatform.ios,
      );
      if (policy == null) {
        return AppUpdateCheckResult.noUpdate(currentVersion: currentVersion);
      }

      final comparison = AppVersionComparator.compare(
        currentVersion,
        policy.minimumVersion,
      );
      if (comparison == null) {
        debugPrint(
          '[CheckForceUpdateUseCase] Invalid version comparison. '
          'current=$currentVersion minimum=${policy.minimumVersion}',
        );
        return AppUpdateCheckResult.noUpdate(currentVersion: currentVersion);
      }

      if (comparison < 0) {
        return AppUpdateCheckResult.forceUpdate(
          currentVersion: currentVersion,
          minimumVersion: policy.minimumVersion,
          storeUrl: policy.storeUrl,
        );
      }

      return AppUpdateCheckResult.noUpdate(currentVersion: currentVersion);
    } catch (error, stackTrace) {
      debugPrint('[CheckForceUpdateUseCase] fallback on failure: $error');
      debugPrint('[CheckForceUpdateUseCase] StackTrace: $stackTrace');
      return const AppUpdateCheckResult.noUpdate(currentVersion: '');
    }
  }
}

final checkForceUpdateUseCaseProvider = Provider<CheckForceUpdateUseCase>((
  ref,
) {
  return CheckForceUpdateUseCase(
    repository: ref.read(appUpdateRepositoryProvider),
    appMetadataService: ref.read(appMetadataServiceProvider),
  );
});

final appUpdateCheckProvider = FutureProvider<AppUpdateCheckResult>((ref) {
  return ref.read(checkForceUpdateUseCaseProvider).call();
});
