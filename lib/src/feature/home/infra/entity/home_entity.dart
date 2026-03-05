import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_entity.freezed.dart';

@freezed
abstract class ProgramEntity with _$ProgramEntity {
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
}
