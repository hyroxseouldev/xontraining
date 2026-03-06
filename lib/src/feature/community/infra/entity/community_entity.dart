class CommunityPostEntity {
  const CommunityPostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.content,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
    required this.isLikedByMe,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String authorAvatarUrl;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likeCount;
  final int commentCount;
  final bool isLikedByMe;

  String get normalizedContent => content.trim();

  String get normalizedAuthorName {
    final value = authorName.trim();
    if (value.isNotEmpty) {
      return value;
    }
    return authorId.substring(0, 8);
  }

  String get normalizedAuthorAvatarUrl => authorAvatarUrl.trim();

  List<String> get normalizedImageUrls => imageUrls
      .map((url) => url.trim())
      .where((url) => url.isNotEmpty)
      .toList();

  CommunityPostEntity copyWith({
    int? likeCount,
    int? commentCount,
    bool? isLikedByMe,
    String? content,
    List<String>? imageUrls,
    DateTime? updatedAt,
  }) {
    return CommunityPostEntity(
      id: id,
      authorId: authorId,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
    );
  }
}

class CommunityCommentEntity {
  const CommunityCommentEntity({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String authorAvatarUrl;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get normalizedContent => content.trim();

  String get normalizedAuthorName {
    final value = authorName.trim();
    if (value.isNotEmpty) {
      return value;
    }
    return authorId.substring(0, 8);
  }

  String get normalizedAuthorAvatarUrl => authorAvatarUrl.trim();
}
