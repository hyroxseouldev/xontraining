enum WorkoutRecordType { time, weight }

class WorkoutExerciseEntity {
  const WorkoutExerciseEntity({
    required this.exerciseKey,
    required this.recordType,
    required this.sortOrder,
    required this.isActive,
  });

  final String exerciseKey;
  final WorkoutRecordType recordType;
  final int sortOrder;
  final bool isActive;

  bool get isCardio => recordType == WorkoutRecordType.time;
}

class WorkoutExercisePresetEntity {
  const WorkoutExercisePresetEntity({
    required this.exerciseKey,
    required this.presetKey,
    required this.sortOrder,
    required this.isActive,
    this.distanceM,
    this.targetReps,
  });

  final String exerciseKey;
  final String presetKey;
  final int? distanceM;
  final int? targetReps;
  final int sortOrder;
  final bool isActive;
}

class WorkoutRecordEntity {
  const WorkoutRecordEntity({
    required this.id,
    required this.exerciseName,
    required this.recordType,
    required this.recordedAt,
    required this.memo,
    this.presetKey,
    this.distance,
    this.recordSeconds,
    this.recordWeightKg,
    this.recordReps,
  });

  final String id;
  final String exerciseName;
  final String? presetKey;
  final WorkoutRecordType recordType;
  final int? distance;
  final int? recordSeconds;
  final double? recordWeightKg;
  final int? recordReps;
  final DateTime recordedAt;
  final String memo;

  bool get isTimeRecord => recordType == WorkoutRecordType.time;
}
