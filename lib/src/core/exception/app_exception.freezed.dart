// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppException {

 Object? get cause;
/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppExceptionCopyWith<AppException> get copyWith => _$AppExceptionCopyWithImpl<AppException>(this as AppException, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppException&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'AppException(cause: $cause)';
}


}

/// @nodoc
abstract mixin class $AppExceptionCopyWith<$Res>  {
  factory $AppExceptionCopyWith(AppException value, $Res Function(AppException) _then) = _$AppExceptionCopyWithImpl;
@useResult
$Res call({
 Object? cause
});




}
/// @nodoc
class _$AppExceptionCopyWithImpl<$Res>
    implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._self, this._then);

  final AppException _self;
  final $Res Function(AppException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cause = freezed,}) {
  return _then(_self.copyWith(
cause: freezed == cause ? _self.cause : cause ,
  ));
}

}


/// Adds pattern-matching-related methods to [AppException].
extension AppExceptionPatterns on AppException {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AuthCanceledException value)?  authCanceled,TResult Function( _AuthConfigurationException value)?  authConfiguration,TResult Function( _AuthNetworkException value)?  authNetwork,TResult Function( _AuthException value)?  auth,TResult Function( _UnknownException value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthCanceledException() when authCanceled != null:
return authCanceled(_that);case _AuthConfigurationException() when authConfiguration != null:
return authConfiguration(_that);case _AuthNetworkException() when authNetwork != null:
return authNetwork(_that);case _AuthException() when auth != null:
return auth(_that);case _UnknownException() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AuthCanceledException value)  authCanceled,required TResult Function( _AuthConfigurationException value)  authConfiguration,required TResult Function( _AuthNetworkException value)  authNetwork,required TResult Function( _AuthException value)  auth,required TResult Function( _UnknownException value)  unknown,}){
final _that = this;
switch (_that) {
case _AuthCanceledException():
return authCanceled(_that);case _AuthConfigurationException():
return authConfiguration(_that);case _AuthNetworkException():
return authNetwork(_that);case _AuthException():
return auth(_that);case _UnknownException():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AuthCanceledException value)?  authCanceled,TResult? Function( _AuthConfigurationException value)?  authConfiguration,TResult? Function( _AuthNetworkException value)?  authNetwork,TResult? Function( _AuthException value)?  auth,TResult? Function( _UnknownException value)?  unknown,}){
final _that = this;
switch (_that) {
case _AuthCanceledException() when authCanceled != null:
return authCanceled(_that);case _AuthConfigurationException() when authConfiguration != null:
return authConfiguration(_that);case _AuthNetworkException() when authNetwork != null:
return authNetwork(_that);case _AuthException() when auth != null:
return auth(_that);case _UnknownException() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Object? cause)?  authCanceled,TResult Function( String message,  Object? cause)?  authConfiguration,TResult Function( Object? cause)?  authNetwork,TResult Function( String message,  Object? cause)?  auth,TResult Function( String message,  Object? cause)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthCanceledException() when authCanceled != null:
return authCanceled(_that.cause);case _AuthConfigurationException() when authConfiguration != null:
return authConfiguration(_that.message,_that.cause);case _AuthNetworkException() when authNetwork != null:
return authNetwork(_that.cause);case _AuthException() when auth != null:
return auth(_that.message,_that.cause);case _UnknownException() when unknown != null:
return unknown(_that.message,_that.cause);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Object? cause)  authCanceled,required TResult Function( String message,  Object? cause)  authConfiguration,required TResult Function( Object? cause)  authNetwork,required TResult Function( String message,  Object? cause)  auth,required TResult Function( String message,  Object? cause)  unknown,}) {final _that = this;
switch (_that) {
case _AuthCanceledException():
return authCanceled(_that.cause);case _AuthConfigurationException():
return authConfiguration(_that.message,_that.cause);case _AuthNetworkException():
return authNetwork(_that.cause);case _AuthException():
return auth(_that.message,_that.cause);case _UnknownException():
return unknown(_that.message,_that.cause);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Object? cause)?  authCanceled,TResult? Function( String message,  Object? cause)?  authConfiguration,TResult? Function( Object? cause)?  authNetwork,TResult? Function( String message,  Object? cause)?  auth,TResult? Function( String message,  Object? cause)?  unknown,}) {final _that = this;
switch (_that) {
case _AuthCanceledException() when authCanceled != null:
return authCanceled(_that.cause);case _AuthConfigurationException() when authConfiguration != null:
return authConfiguration(_that.message,_that.cause);case _AuthNetworkException() when authNetwork != null:
return authNetwork(_that.cause);case _AuthException() when auth != null:
return auth(_that.message,_that.cause);case _UnknownException() when unknown != null:
return unknown(_that.message,_that.cause);case _:
  return null;

}
}

}

/// @nodoc


class _AuthCanceledException implements AppException {
  const _AuthCanceledException({this.cause});
  

@override final  Object? cause;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthCanceledExceptionCopyWith<_AuthCanceledException> get copyWith => __$AuthCanceledExceptionCopyWithImpl<_AuthCanceledException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthCanceledException&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'AppException.authCanceled(cause: $cause)';
}


}

/// @nodoc
abstract mixin class _$AuthCanceledExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory _$AuthCanceledExceptionCopyWith(_AuthCanceledException value, $Res Function(_AuthCanceledException) _then) = __$AuthCanceledExceptionCopyWithImpl;
@override @useResult
$Res call({
 Object? cause
});




}
/// @nodoc
class __$AuthCanceledExceptionCopyWithImpl<$Res>
    implements _$AuthCanceledExceptionCopyWith<$Res> {
  __$AuthCanceledExceptionCopyWithImpl(this._self, this._then);

  final _AuthCanceledException _self;
  final $Res Function(_AuthCanceledException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cause = freezed,}) {
  return _then(_AuthCanceledException(
cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class _AuthConfigurationException implements AppException {
  const _AuthConfigurationException({required this.message, this.cause});
  

 final  String message;
@override final  Object? cause;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthConfigurationExceptionCopyWith<_AuthConfigurationException> get copyWith => __$AuthConfigurationExceptionCopyWithImpl<_AuthConfigurationException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthConfigurationException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'AppException.authConfiguration(message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class _$AuthConfigurationExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory _$AuthConfigurationExceptionCopyWith(_AuthConfigurationException value, $Res Function(_AuthConfigurationException) _then) = __$AuthConfigurationExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, Object? cause
});




}
/// @nodoc
class __$AuthConfigurationExceptionCopyWithImpl<$Res>
    implements _$AuthConfigurationExceptionCopyWith<$Res> {
  __$AuthConfigurationExceptionCopyWithImpl(this._self, this._then);

  final _AuthConfigurationException _self;
  final $Res Function(_AuthConfigurationException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? cause = freezed,}) {
  return _then(_AuthConfigurationException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class _AuthNetworkException implements AppException {
  const _AuthNetworkException({this.cause});
  

@override final  Object? cause;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthNetworkExceptionCopyWith<_AuthNetworkException> get copyWith => __$AuthNetworkExceptionCopyWithImpl<_AuthNetworkException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthNetworkException&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'AppException.authNetwork(cause: $cause)';
}


}

/// @nodoc
abstract mixin class _$AuthNetworkExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory _$AuthNetworkExceptionCopyWith(_AuthNetworkException value, $Res Function(_AuthNetworkException) _then) = __$AuthNetworkExceptionCopyWithImpl;
@override @useResult
$Res call({
 Object? cause
});




}
/// @nodoc
class __$AuthNetworkExceptionCopyWithImpl<$Res>
    implements _$AuthNetworkExceptionCopyWith<$Res> {
  __$AuthNetworkExceptionCopyWithImpl(this._self, this._then);

  final _AuthNetworkException _self;
  final $Res Function(_AuthNetworkException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cause = freezed,}) {
  return _then(_AuthNetworkException(
cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class _AuthException implements AppException {
  const _AuthException({required this.message, this.cause});
  

 final  String message;
@override final  Object? cause;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthExceptionCopyWith<_AuthException> get copyWith => __$AuthExceptionCopyWithImpl<_AuthException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'AppException.auth(message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class _$AuthExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory _$AuthExceptionCopyWith(_AuthException value, $Res Function(_AuthException) _then) = __$AuthExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, Object? cause
});




}
/// @nodoc
class __$AuthExceptionCopyWithImpl<$Res>
    implements _$AuthExceptionCopyWith<$Res> {
  __$AuthExceptionCopyWithImpl(this._self, this._then);

  final _AuthException _self;
  final $Res Function(_AuthException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? cause = freezed,}) {
  return _then(_AuthException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class _UnknownException implements AppException {
  const _UnknownException({required this.message, this.cause});
  

 final  String message;
@override final  Object? cause;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnknownExceptionCopyWith<_UnknownException> get copyWith => __$UnknownExceptionCopyWithImpl<_UnknownException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnknownException&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'AppException.unknown(message: $message, cause: $cause)';
}


}

/// @nodoc
abstract mixin class _$UnknownExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory _$UnknownExceptionCopyWith(_UnknownException value, $Res Function(_UnknownException) _then) = __$UnknownExceptionCopyWithImpl;
@override @useResult
$Res call({
 String message, Object? cause
});




}
/// @nodoc
class __$UnknownExceptionCopyWithImpl<$Res>
    implements _$UnknownExceptionCopyWith<$Res> {
  __$UnknownExceptionCopyWithImpl(this._self, this._then);

  final _UnknownException _self;
  final $Res Function(_UnknownException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? cause = freezed,}) {
  return _then(_UnknownException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,cause: freezed == cause ? _self.cause : cause ,
  ));
}


}

// dart format on
