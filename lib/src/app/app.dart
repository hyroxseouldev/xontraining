import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/brand/brand_provider.dart';
import 'package:xontraining/src/core/app_update/presentation/widget/app_update_gate.dart';
import 'package:xontraining/src/core/router/app_router.dart';

class XonTrainingApp extends ConsumerWidget {
  const XonTrainingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final brand = ref.watch(brandConfigProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) {
        final l10n = AppLocalizations.of(context)!;
        final locale = Localizations.localeOf(context);
        return l10n.appTitle(brand.displayNameFor(locale));
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: brand.lightTheme,
      darkTheme: brand.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        return AppUpdateGate(child: child);
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
