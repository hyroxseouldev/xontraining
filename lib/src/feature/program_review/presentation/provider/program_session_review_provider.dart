import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/program_review/infra/entity/program_session_review_entity.dart';
import 'package:xontraining/src/feature/program_review/infra/usecase/program_session_review_usecases.dart';

part 'program_session_review_provider.g.dart';

@riverpod
Future<Map<String, ProgramSessionReviewEntity>> myProgramSessionReviews(
  Ref ref, {
  required String programId,
}) async {
  final tenantId = ref.read(tenantIdProvider);
  final reviews = await ref
      .read(getMyProgramSessionReviewsUseCaseProvider)
      .call(tenantId: tenantId, programId: programId);

  return {for (final review in reviews) review.sessionId: review};
}

@riverpod
Future<List<CoachProgramSessionReviewEntity>> coachProgramSessionReviews(
  Ref ref, {
  ProgramSessionReviewStatus? status,
}) async {
  final tenantId = ref.read(tenantIdProvider);
  return ref
      .read(getCoachProgramSessionReviewsUseCaseProvider)
      .call(tenantId: tenantId, status: status);
}

@riverpod
class ProgramSessionReviewController extends _$ProgramSessionReviewController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> submitMyReview({
    required String programId,
    required String sessionId,
    required String completionNote,
  }) async {
    state = const AsyncLoading();

    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(createProgramSessionReviewUseCaseProvider)
          .call(
            tenantId: tenantId,
            programId: programId,
            sessionId: sessionId,
            completionNote: completionNote,
          ),
    );

    if (!ref.mounted) {
      return;
    }

    state = nextState;
    if (!state.hasError) {
      ref.invalidate(myProgramSessionReviewsProvider(programId: programId));
    }
  }

  Future<void> updateMyReview({
    required String id,
    required String programId,
    required String completionNote,
  }) async {
    state = const AsyncLoading();

    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(updateProgramSessionReviewUseCaseProvider)
          .call(id: id, tenantId: tenantId, completionNote: completionNote),
    );

    if (!ref.mounted) {
      return;
    }

    state = nextState;
    if (!state.hasError) {
      ref.invalidate(myProgramSessionReviewsProvider(programId: programId));
    }
  }

  Future<void> reviewAsCoach({
    required String id,
    required String programId,
    required String coachFeedback,
  }) async {
    state = const AsyncLoading();

    final tenantId = ref.read(tenantIdProvider);
    final nextState = await AsyncValue.guard(
      () => ref
          .read(reviewProgramSessionUseCaseProvider)
          .call(id: id, tenantId: tenantId, coachFeedback: coachFeedback),
    );

    if (!ref.mounted) {
      return;
    }

    state = nextState;
    if (!state.hasError) {
      ref.invalidate(myProgramSessionReviewsProvider(programId: programId));
      ref.invalidate(coachProgramSessionReviewsProvider());
      ref.invalidate(
        coachProgramSessionReviewsProvider(
          status: ProgramSessionReviewStatus.submitted,
        ),
      );
      ref.invalidate(
        coachProgramSessionReviewsProvider(
          status: ProgramSessionReviewStatus.reviewed,
        ),
      );
    }
  }
}
