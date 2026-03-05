class ProgramSessionEntity {
  const ProgramSessionEntity({
    required this.id,
    required this.sessionDate,
    required this.title,
    required this.contentHtml,
  });

  final String id;
  final DateTime sessionDate;
  final String title;
  final String contentHtml;

  String get normalizedTitle => title.trim();

  String get normalizedContentHtml => contentHtml.trim();
}
