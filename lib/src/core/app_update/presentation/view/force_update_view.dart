import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xontraining/l10n/app_localizations.dart';

class ForceUpdateView extends StatelessWidget {
  const ForceUpdateView({
    required this.currentVersion,
    required this.minimumVersion,
    required this.storeUrl,
    super.key,
  });

  final String currentVersion;
  final String minimumVersion;
  final String storeUrl;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Image.asset(
                          'assets/images/app-icon.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.system_update,
                              size: 44,
                              color: colorScheme.primary,
                            );
                          },
                        ),
                      ),
                    ),
                    Text(
                      l10n.forceUpdateTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.forceUpdateDescription,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _VersionCard(
                      label: l10n.forceUpdateCurrentVersion(currentVersion),
                    ),
                    const SizedBox(height: 12),
                    _VersionCard(
                      label: l10n.forceUpdateMinimumVersion(minimumVersion),
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: () => _openStore(context),
                      child: Text(l10n.forceUpdateAction),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openStore(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final uri = Uri.tryParse(storeUrl.trim());
    final opened =
        uri != null &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.forceUpdateOpenStoreFailed)));
    }
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
