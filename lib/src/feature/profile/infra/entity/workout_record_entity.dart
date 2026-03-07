enum WorkoutRecordType { time, weight }

class WorkoutRecordEntity {
  const WorkoutRecordEntity({
    required this.id,
    required this.exerciseName,
    required this.recordType,
    required this.recordedAt,
    required this.memo,
    this.distance,
    this.recordSeconds,
    this.recordWeightKg,
    this.recordReps,
  });

  final String id;
  final String exerciseName;
  final WorkoutRecordType recordType;
  final int? distance;
  final int? recordSeconds;
  final double? recordWeightKg;
  final int? recordReps;
  final DateTime recordedAt;
  final String memo;

  bool get isTimeRecord => recordType == WorkoutRecordType.time;
}
