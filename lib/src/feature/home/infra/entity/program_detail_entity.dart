enum ProgramSessionType { training, rest }

class ProgramSessionEntity {
  const ProgramSessionEntity({
    required this.id,
    required this.sessionDate,
    required this.title,
    required this.contentHtml,
    required this.isPublished,
    required this.sessionType,
    this.publishAt,
  });

  final String id;
  final DateTime sessionDate;
  final String title;
  final String contentHtml;
  final bool isPublished;
  final DateTime? publishAt;
  final ProgramSessionType sessionType;

  String get normalizedTitle => title.trim();

  String get normalizedContentHtml => contentHtml.trim();

  bool get isRest => sessionType == ProgramSessionType.rest;

  bool get isScheduled {
    final nowUtc = DateTime.now().toUtc();
    final publishAtUtc = publishAt?.toUtc();
    return !isPublished ||
        (publishAtUtc != null && publishAtUtc.isAfter(nowUtc));
  }
}
