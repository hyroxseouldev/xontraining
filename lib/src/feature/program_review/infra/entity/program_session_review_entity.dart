enum ProgramSessionReviewStatus { submitted, reviewed }

class ProgramSessionReviewEntity {
  const ProgramSessionReviewEntity({
    required this.id,
    required this.programId,
    required this.sessionId,
    required this.userId,
    required this.completionNote,
    required this.status,
    required this.coachFeedback,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedBy,
    this.reviewedAt,
  });

  final String id;
  final String programId;
  final String sessionId;
  final String userId;
  final String completionNote;
  final ProgramSessionReviewStatus status;
  final String coachFeedback;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get normalizedCompletionNote => completionNote.trim();

  String get normalizedCoachFeedback => coachFeedback.trim();

  bool get isReviewed => status == ProgramSessionReviewStatus.reviewed;

  bool get hasCoachFeedback => normalizedCoachFeedback.isNotEmpty;

  bool get canEditByMember => !isReviewed;
}

class CoachProgramSessionReviewEntity {
  const CoachProgramSessionReviewEntity({
    required this.review,
    required this.programTitle,
    required this.sessionTitle,
    required this.sessionDate,
    required this.memberName,
    required this.memberAvatarUrl,
  });

  final ProgramSessionReviewEntity review;
  final String programTitle;
  final String sessionTitle;
  final DateTime sessionDate;
  final String memberName;
  final String memberAvatarUrl;

  String get normalizedProgramTitle => programTitle.trim();

  String get normalizedSessionTitle => sessionTitle.trim();

  String get normalizedMemberName {
    final value = memberName.trim();
    if (value.isNotEmpty) {
      return value;
    }
    if (review.userId.length >= 8) {
      return review.userId.substring(0, 8);
    }
    return review.userId;
  }

  String get normalizedMemberAvatarUrl => memberAvatarUrl.trim();
}
