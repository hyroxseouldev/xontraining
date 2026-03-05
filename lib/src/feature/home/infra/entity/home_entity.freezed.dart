// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgramEntity {

 String get id; String get title; String? get description; String? get thumbnailUrl; String? get difficulty; int? get dailyWorkoutMinutes; int? get daysPerWeek; DateTime? get startDate; DateTime? get endDate;
/// Create a copy of ProgramEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramEntityCopyWith<ProgramEntity> get copyWith => _$ProgramEntityCopyWithImpl<ProgramEntity>(this as ProgramEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgramEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.dailyWorkoutMinutes, dailyWorkoutMinutes) || other.dailyWorkoutMinutes == dailyWorkoutMinutes)&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,thumbnailUrl,difficulty,dailyWorkoutMinutes,daysPerWeek,startDate,endDate);

@override
String toString() {
  return 'ProgramEntity(id: $id, title: $title, description: $description, thumbnailUrl: $thumbnailUrl, difficulty: $difficulty, dailyWorkoutMinutes: $dailyWorkoutMinutes, daysPerWeek: $daysPerWeek, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $ProgramEntityCopyWith<$Res>  {
  factory $ProgramEntityCopyWith(ProgramEntity value, $Res Function(ProgramEntity) _then) = _$ProgramEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, String? thumbnailUrl, String? difficulty, int? dailyWorkoutMinutes, int? daysPerWeek, DateTime? startDate, DateTime? endDate
});




}
/// @nodoc
class _$ProgramEntityCopyWithImpl<$Res>
    implements $ProgramEntityCopyWith<$Res> {
  _$ProgramEntityCopyWithImpl(this._self, this._then);

  final ProgramEntity _self;
  final $Res Function(ProgramEntity) _then;

/// Create a copy of ProgramEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? thumbnailUrl = freezed,Object? difficulty = freezed,Object? dailyWorkoutMinutes = freezed,Object? daysPerWeek = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,dailyWorkoutMinutes: freezed == dailyWorkoutMinutes ? _self.dailyWorkoutMinutes : dailyWorkoutMinutes // ignore: cast_nullable_to_non_nullable
as int?,daysPerWeek: freezed == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProgramEntity].
extension ProgramEntityPatterns on ProgramEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgramEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgramEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgramEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProgramEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgramEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProgramEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String? thumbnailUrl,  String? difficulty,  int? dailyWorkoutMinutes,  int? daysPerWeek,  DateTime? startDate,  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgramEntity() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.thumbnailUrl,_that.difficulty,_that.dailyWorkoutMinutes,_that.daysPerWeek,_that.startDate,_that.endDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String? thumbnailUrl,  String? difficulty,  int? dailyWorkoutMinutes,  int? daysPerWeek,  DateTime? startDate,  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _ProgramEntity():
return $default(_that.id,_that.title,_that.description,_that.thumbnailUrl,_that.difficulty,_that.dailyWorkoutMinutes,_that.daysPerWeek,_that.startDate,_that.endDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  String? thumbnailUrl,  String? difficulty,  int? dailyWorkoutMinutes,  int? daysPerWeek,  DateTime? startDate,  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _ProgramEntity() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.thumbnailUrl,_that.difficulty,_that.dailyWorkoutMinutes,_that.daysPerWeek,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _ProgramEntity implements ProgramEntity {
  const _ProgramEntity({required this.id, required this.title, this.description, this.thumbnailUrl, this.difficulty, this.dailyWorkoutMinutes, this.daysPerWeek, this.startDate, this.endDate});
  

@override final  String id;
@override final  String title;
@override final  String? description;
@override final  String? thumbnailUrl;
@override final  String? difficulty;
@override final  int? dailyWorkoutMinutes;
@override final  int? daysPerWeek;
@override final  DateTime? startDate;
@override final  DateTime? endDate;

/// Create a copy of ProgramEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramEntityCopyWith<_ProgramEntity> get copyWith => __$ProgramEntityCopyWithImpl<_ProgramEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgramEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.dailyWorkoutMinutes, dailyWorkoutMinutes) || other.dailyWorkoutMinutes == dailyWorkoutMinutes)&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,thumbnailUrl,difficulty,dailyWorkoutMinutes,daysPerWeek,startDate,endDate);

@override
String toString() {
  return 'ProgramEntity(id: $id, title: $title, description: $description, thumbnailUrl: $thumbnailUrl, difficulty: $difficulty, dailyWorkoutMinutes: $dailyWorkoutMinutes, daysPerWeek: $daysPerWeek, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$ProgramEntityCopyWith<$Res> implements $ProgramEntityCopyWith<$Res> {
  factory _$ProgramEntityCopyWith(_ProgramEntity value, $Res Function(_ProgramEntity) _then) = __$ProgramEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, String? thumbnailUrl, String? difficulty, int? dailyWorkoutMinutes, int? daysPerWeek, DateTime? startDate, DateTime? endDate
});




}
/// @nodoc
class __$ProgramEntityCopyWithImpl<$Res>
    implements _$ProgramEntityCopyWith<$Res> {
  __$ProgramEntityCopyWithImpl(this._self, this._then);

  final _ProgramEntity _self;
  final $Res Function(_ProgramEntity) _then;

/// Create a copy of ProgramEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? thumbnailUrl = freezed,Object? difficulty = freezed,Object? dailyWorkoutMinutes = freezed,Object? daysPerWeek = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_ProgramEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,dailyWorkoutMinutes: freezed == dailyWorkoutMinutes ? _self.dailyWorkoutMinutes : dailyWorkoutMinutes // ignore: cast_nullable_to_non_nullable
as int?,daysPerWeek: freezed == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
