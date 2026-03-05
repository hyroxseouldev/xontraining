class ProgramSessionEntity {
  const ProgramSessionEntity({
    required this.id,
    required this.sessionDate,
    required this.title,
    required this.contentHtml,
    this.week,
    this.dayLabel,
  });

  final String id;
  final DateTime sessionDate;
  final String title;
  final String contentHtml;
  final int? week;
  final String? dayLabel;

  String get normalizedTitle => title.trim();

  String get normalizedContentHtml => contentHtml.trim();
}
