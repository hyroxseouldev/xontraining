import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/brand/brand_provider.dart';

part 'tenant_provider.g.dart';

@riverpod
String tenantId(Ref ref) {
  return ref.watch(brandConfigProvider).tenantId;
}
