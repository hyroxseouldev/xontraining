import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/home/data/repository/home_repository.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';

part 'home_usecases.g.dart';

class GetProgramsByTenantUseCase {
  GetProgramsByTenantUseCase({required this.repository});

  final HomeRepository repository;

  Future<List<ProgramEntity>> call({required String tenantId}) {
    return repository.getProgramsByTenant(tenantId: tenantId);
  }
}

@riverpod
GetProgramsByTenantUseCase getProgramsByTenantUseCase(Ref ref) {
  return GetProgramsByTenantUseCase(
    repository: ref.read(homeRepositoryProvider),
  );
}
