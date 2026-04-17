import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/program_review/data/repository/program_session_review_repository.dart';
import 'package:xontraining/src/feature/program_review/infra/entity/program_session_review_entity.dart';

part 'program_session_review_usecases.g.dart';

class GetMyProgramSessionReviewsUseCase {
  GetMyProgramSessionReviewsUseCase({required this.repository});

  final ProgramSessionReviewRepository repository;

  Future<List<ProgramSessionReviewEntity>> call({
    required String tenantId,
    required String programId,
  }) {
    return repository.getMySessionReviewsByProgram(
      tenantId: tenantId,
      programId: programId,
    );
  }
}

class CreateProgramSessionReviewUseCase {
  CreateProgramSessionReviewUseCase({required this.repository});

  final ProgramSessionReviewRepository repository;

  Future<void> call({
    required String tenantId,
    required String programId,
    required String sessionId,
    required String completionNote,
  }) {
    return repository.createMySessionReview(
      tenantId: tenantId,
      programId: programId,
      sessionId: sessionId,
      completionNote: completionNote,
    );
  }
}

class UpdateProgramSessionReviewUseCase {
  UpdateProgramSessionReviewUseCase({required this.repository});

  final ProgramSessionReviewRepository repository;

  Future<void> call({
    required String id,
    required String tenantId,
    required String completionNote,
  }) {
    return repository.updateMySessionReview(
      id: id,
      tenantId: tenantId,
      completionNote: completionNote,
    );
  }
}

class GetCoachProgramSessionReviewsUseCase {
  GetCoachProgramSessionReviewsUseCase({required this.repository});

  final ProgramSessionReviewRepository repository;

  Future<List<CoachProgramSessionReviewEntity>> call({
    required String tenantId,
    ProgramSessionReviewStatus? status,
  }) {
    return repository.getCoachSessionReviews(
      tenantId: tenantId,
      status: status,
    );
  }
}

class ReviewProgramSessionUseCase {
  ReviewProgramSessionUseCase({required this.repository});

  final ProgramSessionReviewRepository repository;

  Future<void> call({
    required String id,
    required String tenantId,
    required String coachFeedback,
  }) {
    return repository.reviewSessionReview(
      id: id,
      tenantId: tenantId,
      coachFeedback: coachFeedback,
    );
  }
}

@riverpod
GetMyProgramSessionReviewsUseCase getMyProgramSessionReviewsUseCase(Ref ref) {
  return GetMyProgramSessionReviewsUseCase(
    repository: ref.read(programSessionReviewRepositoryProvider),
  );
}

@riverpod
CreateProgramSessionReviewUseCase createProgramSessionReviewUseCase(Ref ref) {
  return CreateProgramSessionReviewUseCase(
    repository: ref.read(programSessionReviewRepositoryProvider),
  );
}

@riverpod
UpdateProgramSessionReviewUseCase updateProgramSessionReviewUseCase(Ref ref) {
  return UpdateProgramSessionReviewUseCase(
    repository: ref.read(programSessionReviewRepositoryProvider),
  );
}

@riverpod
GetCoachProgramSessionReviewsUseCase getCoachProgramSessionReviewsUseCase(
  Ref ref,
) {
  return GetCoachProgramSessionReviewsUseCase(
    repository: ref.read(programSessionReviewRepositoryProvider),
  );
}

@riverpod
ReviewProgramSessionUseCase reviewProgramSessionUseCase(Ref ref) {
  return ReviewProgramSessionUseCase(
    repository: ref.read(programSessionReviewRepositoryProvider),
  );
}
