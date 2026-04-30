import 'package:xontraining/src/app/bootstrap.dart';
import 'package:xontraining/src/app/flavor.dart';
import 'package:xontraining/src/core/brand/brand.dart';

Future<void> main() async {
  await bootstrap(flavor: AppFlavor.dev, brand: Brand.amor);
}
