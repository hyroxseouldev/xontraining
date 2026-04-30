import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/brand/brand.dart';
import 'package:xontraining/src/core/brand/brand_provider.dart';
import 'package:xontraining/src/feature/auth/presentation/view/login_view.dart';
import 'package:xontraining/src/feature/onboarding/presentation/view/onboarding_view.dart';

void main() {
  testWidgets('Login screen is shown', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [brandProvider.overrideWithValue(Brand.xon)],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginView(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign in with Google'), findsOneWidget);
  });

  testWidgets('Onboarding screen is shown', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [brandProvider.overrideWithValue(Brand.xon)],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: OnboardingView(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
  });
}
