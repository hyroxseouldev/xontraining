class NoticeEntity {
  const NoticeEntity({
    required this.id,
    required this.title,
    required this.contentHtml,
    required this.thumbnailUrl,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String contentHtml;
  final String thumbnailUrl;
  final DateTime createdAt;

  String get normalizedTitle => title.trim();

  String get normalizedThumbnailUrl => thumbnailUrl.trim();

  bool get hasThumbnailUrl => normalizedThumbnailUrl.isNotEmpty;

  String get contentPreview {
    final withoutTags = contentHtml.replaceAll(RegExp(r'<[^>]*>'), ' ');
    final singleLine = withoutTags.replaceAll(RegExp(r'\s+'), ' ').trim();
    return singleLine;
  }
}
