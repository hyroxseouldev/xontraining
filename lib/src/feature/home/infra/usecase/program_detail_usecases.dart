import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/feature/home/data/repository/home_repository.dart';
import 'package:xontraining/src/feature/home/infra/entity/coach_info_entity.dart';
import 'package:xontraining/src/feature/home/infra/entity/program_detail_entity.dart';

class CheckProgramAccessUseCase {
  CheckProgramAccessUseCase({required this.repository});

  final HomeRepository repository;

  Future<bool> call({
    required String tenantId,
    required String userId,
    required String programId,
  }) {
    return repository.hasProgramAccess(
      tenantId: tenantId,
      userId: userId,
      programId: programId,
    );
  }
}

class GetProgramSessionsUseCase {
  GetProgramSessionsUseCase({required this.repository});

  final HomeRepository repository;

  Future<List<ProgramSessionEntity>> call({
    required String tenantId,
    required String programId,
  }) {
    return repository.getSessionsByProgram(
      tenantId: tenantId,
      programId: programId,
    );
  }
}

class GetCoachInfoUseCase {
  GetCoachInfoUseCase({required this.repository});

  final HomeRepository repository;

  Future<CoachInfoEntity?> call({required String tenantId}) {
    return repository.getCoachInfoByTenant(tenantId: tenantId);
  }
}

final checkProgramAccessUseCaseProvider = Provider<CheckProgramAccessUseCase>((
  ref,
) {
  return CheckProgramAccessUseCase(
    repository: ref.read(homeRepositoryProvider),
  );
});

final getProgramSessionsUseCaseProvider = Provider<GetProgramSessionsUseCase>((
  ref,
) {
  return GetProgramSessionsUseCase(
    repository: ref.read(homeRepositoryProvider),
  );
});

final getCoachInfoUseCaseProvider = Provider<GetCoachInfoUseCase>((ref) {
  return GetCoachInfoUseCase(repository: ref.read(homeRepositoryProvider));
});
