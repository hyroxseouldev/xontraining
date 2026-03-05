enum WorkoutRecordMetricType { weight, reps, distance, duration }

class WorkoutRecordEntity {
  const WorkoutRecordEntity({
    required this.id,
    required this.exerciseName,
    required this.metricType,
    required this.unit,
    required this.recordedAt,
    required this.memo,
    this.valueNumeric,
    this.valueSeconds,
  });

  final String id;
  final String exerciseName;
  final WorkoutRecordMetricType metricType;
  final double? valueNumeric;
  final int? valueSeconds;
  final String unit;
  final DateTime recordedAt;
  final String memo;

  bool get usesDuration => metricType == WorkoutRecordMetricType.duration;
}
