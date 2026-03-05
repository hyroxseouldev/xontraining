import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/home/data/repository/home_repository.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';

part 'home_usecases.g.dart';

class GetCurrentActiveProgramUseCase {
  GetCurrentActiveProgramUseCase({required this.repository});

  final HomeRepository repository;

  Future<ActiveProgramEntity?> call() {
    return repository.getCurrentActiveProgram();
  }
}

class GetBlueprintSectionsUseCase {
  GetBlueprintSectionsUseCase({required this.repository});

  final HomeRepository repository;

  Future<List<BlueprintSectionEntity>> call({
    required String programId,
    required DateTime date,
  }) {
    return repository.getBlueprintSectionsByDate(
      programId: programId,
      date: date,
    );
  }
}

@riverpod
GetCurrentActiveProgramUseCase getCurrentActiveProgramUseCase(Ref ref) {
  return GetCurrentActiveProgramUseCase(
    repository: ref.read(homeRepositoryProvider),
  );
}

@riverpod
GetBlueprintSectionsUseCase getBlueprintSectionsUseCase(Ref ref) {
  return GetBlueprintSectionsUseCase(
    repository: ref.read(homeRepositoryProvider),
  );
}
