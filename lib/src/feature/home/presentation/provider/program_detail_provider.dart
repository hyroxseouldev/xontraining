import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';
import 'package:xontraining/src/feature/home/infra/entity/coach_info_entity.dart';
import 'package:xontraining/src/feature/home/infra/entity/program_detail_entity.dart';
import 'package:xontraining/src/feature/home/infra/usecase/program_detail_usecases.dart';

class ProgramDetailPayload {
  const ProgramDetailPayload({required this.canAccess, required this.sessions});

  final bool canAccess;
  final List<ProgramSessionEntity> sessions;
}

final programDetailPayloadProvider =
    FutureProvider.family<ProgramDetailPayload, String>((ref, programId) async {
      final tenantId = ref.read(tenantIdProvider);
      final user = await ref.watch(authSessionProvider.future);
      if (user == null) {
        return const ProgramDetailPayload(canAccess: false, sessions: []);
      }

      final canAccess = await ref
          .read(checkProgramAccessUseCaseProvider)
          .call(tenantId: tenantId, userId: user.id, programId: programId);
      if (!canAccess) {
        return const ProgramDetailPayload(canAccess: false, sessions: []);
      }

      final sessions = await ref
          .read(getProgramSessionsUseCaseProvider)
          .call(tenantId: tenantId, programId: programId);
      return ProgramDetailPayload(canAccess: true, sessions: sessions);
    });

final coachInfoProvider = FutureProvider.family<List<CoachInfoEntity>, String>((
  ref,
  programId,
) async {
  final tenantId = ref.read(tenantIdProvider);
  return ref
      .read(getCoachInfoUseCaseProvider)
      .call(tenantId: tenantId, programId: programId);
});
