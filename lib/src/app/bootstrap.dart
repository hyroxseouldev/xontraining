import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xontraining/src/app/app.dart';
import 'package:xontraining/src/app/flavor.dart';
import 'package:xontraining/src/core/brand/brand.dart';
import 'package:xontraining/src/core/brand/brand_provider.dart';
import 'package:xontraining/src/core/config/env/env.dart';

Future<void> bootstrap({
  required AppFlavor flavor,
  required Brand brand,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  final iosClientId = Env.googleIosClientId.isEmpty
      ? null
      : Env.googleIosClientId;
  if (!kIsWeb &&
      defaultTargetPlatform == TargetPlatform.iOS &&
      iosClientId == null) {
    debugPrint(
      '[Auth] GOOGLE_IOS_CLIENT_ID is empty. Google Sign-In can fail on iOS.',
    );
  }

  await GoogleSignIn.instance.initialize(
    clientId: iosClientId,
    serverClientId: Env.googleWebClientId.isEmpty
        ? null
        : Env.googleWebClientId,
  );

  debugPrint('[App] Bootstrapped with flavor: $flavor');
  runApp(
    ProviderScope(
      overrides: [brandProvider.overrideWithValue(brand)],
      child: const XonTrainingApp(),
    ),
  );
}
