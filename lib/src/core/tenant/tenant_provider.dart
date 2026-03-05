import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/config/env/env.dart';
import 'package:xontraining/src/core/exception/app_exception.dart';

part 'tenant_provider.g.dart';

@riverpod
String tenantId(Ref ref) {
  final id = Env.tenantId.trim();
  if (id.isEmpty) {
    throw const AppException.authConfiguration(
      message: 'TENANT_ID is not configured.',
    );
  }
  return id;
}
