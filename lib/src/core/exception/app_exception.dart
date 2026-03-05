import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
sealed class AppException with _$AppException implements Exception {
  const factory AppException.authCanceled({Object? cause}) =
      _AuthCanceledException;

  const factory AppException.authConfiguration({
    required String message,
    Object? cause,
  }) = _AuthConfigurationException;

  const factory AppException.authNetwork({Object? cause}) =
      _AuthNetworkException;

  const factory AppException.auth({required String message, Object? cause}) =
      _AuthException;

  const factory AppException.unknown({required String message, Object? cause}) =
      _UnknownException;
}
