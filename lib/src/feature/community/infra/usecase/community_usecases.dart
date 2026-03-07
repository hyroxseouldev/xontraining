import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/src/feature/community/data/repository/community_repository.dart';
import 'package:xontraining/src/feature/community/infra/entity/community_entity.dart';

class GetCommunityPostsPageUseCase {
  GetCommunityPostsPageUseCase({required this.repository});

  final CommunityRepository repository;

  Future<List<CommunityPostEntity>> call({
    required String tenantId,
    required int limit,
    required int offset,
  }) {
    return repository.getPostsPage(
      tenantId: tenantId,
      limit: limit,
      offset: offset,
    );
  }
}

class GetCommunityPostDetailUseCase {
  GetCommunityPostDetailUseCase({required this.repository});

  final CommunityRepository repository;

  Future<CommunityPostEntity> call({
    required String tenantId,
    required String postId,
  }) {
    return repository.getPostDetail(tenantId: tenantId, postId: postId);
  }
}

class GetCommunityCommentsUseCase {
  GetCommunityCommentsUseCase({required this.repository});

  final CommunityRepository repository;

  Future<List<CommunityCommentEntity>> call({
    required String tenantId,
    required String postId,
  }) {
    return repository.getComments(tenantId: tenantId, postId: postId);
  }
}

class CreateCommunityPostUseCase {
  CreateCommunityPostUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({
    required String tenantId,
    required String content,
    required List<String> imageUrls,
  }) {
    return repository.createPost(
      tenantId: tenantId,
      content: content,
      imageUrls: imageUrls,
    );
  }
}

class UpdateCommunityPostUseCase {
  UpdateCommunityPostUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({
    required String tenantId,
    required String postId,
    required String content,
    required List<String> imageUrls,
  }) {
    return repository.updatePost(
      tenantId: tenantId,
      postId: postId,
      content: content,
      imageUrls: imageUrls,
    );
  }
}

class DeleteCommunityPostUseCase {
  DeleteCommunityPostUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({required String tenantId, required String postId}) {
    return repository.deletePost(tenantId: tenantId, postId: postId);
  }
}

class CreateCommunityCommentUseCase {
  CreateCommunityCommentUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({
    required String tenantId,
    required String postId,
    required String content,
  }) {
    return repository.createComment(
      tenantId: tenantId,
      postId: postId,
      content: content,
    );
  }
}

class DeleteCommunityCommentUseCase {
  DeleteCommunityCommentUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({required String tenantId, required String commentId}) {
    return repository.deleteComment(tenantId: tenantId, commentId: commentId);
  }
}

class SetCommunityPostLikeUseCase {
  SetCommunityPostLikeUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({
    required String tenantId,
    required String postId,
    required bool like,
  }) {
    return repository.setPostLiked(
      tenantId: tenantId,
      postId: postId,
      like: like,
    );
  }
}

class ReportCommunityPostUseCase {
  ReportCommunityPostUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({
    required String tenantId,
    required String postId,
    required String reason,
    required String detail,
  }) {
    return repository.reportPost(
      tenantId: tenantId,
      postId: postId,
      reason: reason,
      detail: detail,
    );
  }
}

class ReportCommunityCommentUseCase {
  ReportCommunityCommentUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({
    required String tenantId,
    required String commentId,
    required String reason,
    required String detail,
  }) {
    return repository.reportComment(
      tenantId: tenantId,
      commentId: commentId,
      reason: reason,
      detail: detail,
    );
  }
}

class HideCommunityPostUseCase {
  HideCommunityPostUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({required String tenantId, required String postId}) {
    return repository.hidePost(tenantId: tenantId, postId: postId);
  }
}

class BlockCommunityUserUseCase {
  BlockCommunityUserUseCase({required this.repository});

  final CommunityRepository repository;

  Future<void> call({required String tenantId, required String blockedUserId}) {
    return repository.blockUser(
      tenantId: tenantId,
      blockedUserId: blockedUserId,
    );
  }
}

final getCommunityPostsPageUseCaseProvider =
    Provider<GetCommunityPostsPageUseCase>((ref) {
      return GetCommunityPostsPageUseCase(
        repository: ref.read(communityRepositoryProvider),
      );
    });

final getCommunityPostDetailUseCaseProvider =
    Provider<GetCommunityPostDetailUseCase>((ref) {
      return GetCommunityPostDetailUseCase(
        repository: ref.read(communityRepositoryProvider),
      );
    });

final getCommunityCommentsUseCaseProvider =
    Provider<GetCommunityCommentsUseCase>((ref) {
      return GetCommunityCommentsUseCase(
        repository: ref.read(communityRepositoryProvider),
      );
    });

final createCommunityPostUseCaseProvider = Provider<CreateCommunityPostUseCase>(
  (ref) {
    return CreateCommunityPostUseCase(
      repository: ref.read(communityRepositoryProvider),
    );
  },
);

final updateCommunityPostUseCaseProvider = Provider<UpdateCommunityPostUseCase>(
  (ref) {
    return UpdateCommunityPostUseCase(
      repository: ref.read(communityRepositoryProvider),
    );
  },
);

final deleteCommunityPostUseCaseProvider = Provider<DeleteCommunityPostUseCase>(
  (ref) {
    return DeleteCommunityPostUseCase(
      repository: ref.read(communityRepositoryProvider),
    );
  },
);

final createCommunityCommentUseCaseProvider =
    Provider<CreateCommunityCommentUseCase>((ref) {
      return CreateCommunityCommentUseCase(
        repository: ref.read(communityRepositoryProvider),
      );
    });

final deleteCommunityCommentUseCaseProvider =
    Provider<DeleteCommunityCommentUseCase>((ref) {
      return DeleteCommunityCommentUseCase(
        repository: ref.read(communityRepositoryProvider),
      );
    });

final setCommunityPostLikeUseCaseProvider =
    Provider<SetCommunityPostLikeUseCase>((ref) {
      return SetCommunityPostLikeUseCase(
        repository: ref.read(communityRepositoryProvider),
      );
    });

final reportCommunityPostUseCaseProvider = Provider<ReportCommunityPostUseCase>(
  (ref) {
    return ReportCommunityPostUseCase(
      repository: ref.read(communityRepositoryProvider),
    );
  },
);

final reportCommunityCommentUseCaseProvider =
    Provider<ReportCommunityCommentUseCase>((ref) {
      return ReportCommunityCommentUseCase(
        repository: ref.read(communityRepositoryProvider),
      );
    });

final hideCommunityPostUseCaseProvider = Provider<HideCommunityPostUseCase>((
  ref,
) {
  return HideCommunityPostUseCase(
    repository: ref.read(communityRepositoryProvider),
  );
});

final blockCommunityUserUseCaseProvider = Provider<BlockCommunityUserUseCase>((
  ref,
) {
  return BlockCommunityUserUseCase(
    repository: ref.read(communityRepositoryProvider),
  );
});
