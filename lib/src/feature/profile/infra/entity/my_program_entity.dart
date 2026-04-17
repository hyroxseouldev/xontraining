import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';

enum MyProgramStatus { active, inactive }

class MyProgramItemEntity {
  const MyProgramItemEntity({
    required this.program,
    required this.isEntitlementActive,
    required this.activationStartAt,
    required this.activationEndAt,
  });

  final ProgramEntity program;
  final bool isEntitlementActive;
  final DateTime? activationStartAt;
  final DateTime? activationEndAt;
}

class MyProgramPageEntity {
  const MyProgramPageEntity({
    required this.items,
    required this.totalCount,
    required this.nextOffset,
    required this.hasMore,
  });

  final List<MyProgramItemEntity> items;
  final int totalCount;
  final int nextOffset;
  final bool hasMore;
}
