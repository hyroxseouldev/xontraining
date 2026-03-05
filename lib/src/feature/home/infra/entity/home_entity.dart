import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_entity.freezed.dart';

@freezed
abstract class ActiveProgramEntity with _$ActiveProgramEntity {
  const factory ActiveProgramEntity({
    required String id,
    required String title,
    String? thumbnailUrl,
    String? shortDescription,
    String? description,
  }) = _ActiveProgramEntity;
}

@freezed
abstract class BlueprintSectionEntity with _$BlueprintSectionEntity {
  const factory BlueprintSectionEntity({
    required String id,
    required String title,
    required String content,
    required int orderIndex,
  }) = _BlueprintSectionEntity;
}

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    required DateTime selectedDate,
    ActiveProgramEntity? activeProgram,
    @Default(<BlueprintSectionEntity>[]) List<BlueprintSectionEntity> sections,
  }) = _HomeState;
}
