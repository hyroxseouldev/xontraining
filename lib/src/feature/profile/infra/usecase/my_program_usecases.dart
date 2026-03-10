import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/feature/profile/data/repository/my_program_repository.dart';
import 'package:xontraining/src/feature/profile/infra/entity/my_program_entity.dart';

class GetMyProgramsPageUseCase {
  GetMyProgramsPageUseCase({required this.repository});

  final MyProgramRepository repository;

  Future<MyProgramPageEntity> call({
    required String tenantId,
    required String userId,
    required MyProgramStatus status,
    required int limit,
    required int offset,
  }) {
    return repository.getMyProgramsPage(
      tenantId: tenantId,
      userId: userId,
      status: status,
      limit: limit,
      offset: offset,
    );
  }
}

final getMyProgramsPageUseCaseProvider = Provider<GetMyProgramsPageUseCase>((
  ref,
) {
  return GetMyProgramsPageUseCase(
    repository: ref.read(myProgramRepositoryProvider),
  );
});
