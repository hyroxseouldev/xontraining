import 'package:flutter_test/flutter_test.dart';
import 'package:xontraining/src/core/app_update/data/repository/app_update_repository.dart';
import 'package:xontraining/src/core/app_update/infra/entity/app_update_policy_entity.dart';
import 'package:xontraining/src/core/app_update/infra/service/app_metadata_service.dart';
import 'package:xontraining/src/core/app_update/infra/usecase/check_force_update_usecase.dart';

void main() {
  group('CheckForceUpdateUseCase', () {
    test('requires force update when current version is lower', () async {
      final useCase = CheckForceUpdateUseCase(
        repository: _FakeAppUpdateRepository(
          policy: const AppUpdatePolicyEntity(
            platform: AppUpdatePlatform.ios,
            minimumVersion: '1.0.1',
            storeUrl: 'https://apps.apple.com/app/id123456789',
            isActive: true,
          ),
        ),
        appMetadataService: _FakeAppMetadataService(
          isIos: true,
          version: '1.0.0',
        ),
      );

      final result = await useCase.call();

      expect(result.requiresForceUpdate, isTrue);
      expect(result.minimumVersion, '1.0.1');
    });

    test('allows app when current version matches minimum version', () async {
      final useCase = CheckForceUpdateUseCase(
        repository: _FakeAppUpdateRepository(
          policy: const AppUpdatePolicyEntity(
            platform: AppUpdatePlatform.ios,
            minimumVersion: '1.0.1',
            storeUrl: 'https://apps.apple.com/app/id123456789',
            isActive: true,
          ),
        ),
        appMetadataService: _FakeAppMetadataService(
          isIos: true,
          version: '1.0.1',
        ),
      );

      final result = await useCase.call();

      expect(result.requiresForceUpdate, isFalse);
    });

    test('skips check on non-ios platforms', () async {
      final repository = _FakeAppUpdateRepository(
        policy: const AppUpdatePolicyEntity(
          platform: AppUpdatePlatform.ios,
          minimumVersion: '1.0.1',
          storeUrl: 'https://apps.apple.com/app/id123456789',
          isActive: true,
        ),
      );
      final useCase = CheckForceUpdateUseCase(
        repository: repository,
        appMetadataService: _FakeAppMetadataService(
          isIos: false,
          version: '1.0.0',
        ),
      );

      final result = await useCase.call();

      expect(result.requiresForceUpdate, isFalse);
      expect(repository.getPolicyCalls, 0);
    });

    test('fails open when policy is unavailable', () async {
      final useCase = CheckForceUpdateUseCase(
        repository: _FakeAppUpdateRepository(),
        appMetadataService: _FakeAppMetadataService(
          isIos: true,
          version: '1.0.0',
        ),
      );

      final result = await useCase.call();

      expect(result.requiresForceUpdate, isFalse);
    });
  });
}

class _FakeAppMetadataService implements AppMetadataService {
  _FakeAppMetadataService({required this.isIos, required this.version});

  @override
  final bool isIos;

  final String version;

  @override
  Future<String> getAppVersion() async => version;
}

class _FakeAppUpdateRepository implements AppUpdateRepository {
  _FakeAppUpdateRepository({this.policy});

  final AppUpdatePolicyEntity? policy;
  int getPolicyCalls = 0;

  @override
  Future<AppUpdatePolicyEntity?> getActivePolicy({
    required AppUpdatePlatform platform,
  }) async {
    getPolicyCalls += 1;
    return policy;
  }
}
