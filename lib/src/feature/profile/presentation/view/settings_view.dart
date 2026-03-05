import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_controller.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/profile_provider.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final versionLabel = ref.watch(appVersionLabelProvider);
    final tenantRole = ref.watch(profileTenantRoleProvider);
    final canDeleteAccount = tenantRole.asData?.value == 'member';
    final isBusy = authState.isLoading;

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      if ((previous?.isLoading ?? false) && next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.settingsActionFailed)));
      }
    });

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
                l10n.settingsTitle,
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
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.settingsAppVersion),
                subtitle: Text(
                  versionLabel.maybeWhen(
                    data: (value) => value,
                    orElse: () => l10n.settingsVersionLoading,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                onTap: () => context.pushNamed(AppRoutes.termsOfServiceName),
                leading: const Icon(Icons.description_outlined),
                title: Text(l10n.settingsTermsOfService),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                onTap: () => context.pushNamed(AppRoutes.privacyPolicyName),
                leading: const Icon(Icons.privacy_tip_outlined),
                title: Text(l10n.settingsPrivacyPolicy),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                enabled: canDeleteAccount && !isBusy,
                onTap: !canDeleteAccount || isBusy
                    ? null
                    : () => _onDeleteAccountPressed(context, ref, l10n),
                leading: const Icon(Icons.delete_forever_outlined),
                title: Text(l10n.settingsDeleteAccount),
                subtitle: Text(
                  canDeleteAccount
                      ? l10n.settingsDeleteAccountSubtitle
                      : l10n.settingsDeleteAccountMemberOnly,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                enabled: !isBusy,
                onTap: isBusy
                    ? null
                    : () => ref.read(authControllerProvider.notifier).signOut(),
                leading: const Icon(Icons.logout),
                title: Text(l10n.settingsSignOut),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteAccountPressed(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.settingsDeleteAccountDialogTitle),
          content: Text(l10n.settingsDeleteAccountDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.settingsDeleteAccountCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.settingsDeleteAccountConfirm),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await ref.read(authControllerProvider.notifier).deleteMyAccount();

    if (!context.mounted) {
      return;
    }

    final nextState = ref.read(authControllerProvider);
    if (nextState.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.settingsDeleteAccountFailed)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.settingsDeleteAccountSuccess)));
  }
}
