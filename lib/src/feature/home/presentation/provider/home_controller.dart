import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xontraining/src/core/tenant/tenant_provider.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/infra/usecase/home_usecases.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  Future<List<ProgramEntity>> build() async {
    final tenantId = ref.read(tenantIdProvider);
    return ref
        .read(getProgramsByTenantUseCaseProvider)
        .call(tenantId: tenantId);
  }
}
