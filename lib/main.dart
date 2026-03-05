import 'package:xontraining/src/app/bootstrap.dart';
import 'package:xontraining/src/app/flavor.dart';

Future<void> main() async {
  await bootstrap(flavor: AppFlavor.dev);
}
