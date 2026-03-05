import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/feature/notice/data/repository/notice_repository.dart';
import 'package:xontraining/src/feature/notice/infra/entity/notice_entity.dart';

part 'notice_usecases.g.dart';

class GetNoticesPageUseCase {
  GetNoticesPageUseCase({required this.repository});

  final NoticeRepository repository;

  Future<List<NoticeEntity>> call({
    required String tenantId,
    required int limit,
    required int offset,
  }) {
    return repository.getNoticesPage(
      tenantId: tenantId,
      limit: limit,
      offset: offset,
    );
  }
}

class GetNoticeByIdUseCase {
  GetNoticeByIdUseCase({required this.repository});

  final NoticeRepository repository;

  Future<NoticeEntity> call({
    required String tenantId,
    required String noticeId,
  }) {
    return repository.getNoticeById(tenantId: tenantId, noticeId: noticeId);
  }
}

@riverpod
GetNoticesPageUseCase getNoticesPageUseCase(Ref ref) {
  return GetNoticesPageUseCase(repository: ref.read(noticeRepositoryProvider));
}

@riverpod
GetNoticeByIdUseCase getNoticeByIdUseCase(Ref ref) {
  return GetNoticeByIdUseCase(repository: ref.read(noticeRepositoryProvider));
}
