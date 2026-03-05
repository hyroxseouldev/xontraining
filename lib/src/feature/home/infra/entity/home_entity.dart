import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_entity.freezed.dart';

@freezed
abstract class ProgramEntity with _$ProgramEntity {
  const ProgramEntity._();

  const factory ProgramEntity({
    required String id,
    required String title,
    String? description,
    String? thumbnailUrl,
    String? difficulty,
    int? dailyWorkoutMinutes,
    int? daysPerWeek,
    DateTime? startDate,
    DateTime? endDate,
  }) = _ProgramEntity;

  String get normalizedDifficulty => difficulty?.trim() ?? '';

  bool get hasDifficulty => normalizedDifficulty.isNotEmpty;

  String get normalizedDescription => description?.trim() ?? '';

  bool get hasDescription => normalizedDescription.isNotEmpty;

  String get normalizedThumbnailUrl => thumbnailUrl?.trim() ?? '';

  bool get hasThumbnailUrl => normalizedThumbnailUrl.isNotEmpty;

  int? get durationWeeks {
    final valueStartDate = startDate;
    final valueEndDate = endDate;
    if (valueStartDate == null || valueEndDate == null) {
      return null;
    }

    final days = valueEndDate.difference(valueStartDate).inDays.abs() + 1;
    final weekCount = (days / 7).ceil();
    if (weekCount < 1) {
      return 1;
    }
    if (weekCount > 999) {
      return 999;
    }
    return weekCount;
  }
}
