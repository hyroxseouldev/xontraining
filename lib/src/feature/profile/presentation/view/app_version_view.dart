import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/brand/brand_provider.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/profile_provider.dart';

class AppVersionView extends ConsumerWidget {
  const AppVersionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final brand = ref.watch(brandConfigProvider);
    final versionLabel = ref.watch(appVersionLabelProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                l10n.settingsAppVersion,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  height: 1.1,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // border grey
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Image.asset(
                    brand.logoAssetPath,
                    height: 120,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(height: 180),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.settingsAppVersion,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  versionLabel.maybeWhen(
                    data: (value) => value,
                    orElse: () => l10n.settingsVersionLoading,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
