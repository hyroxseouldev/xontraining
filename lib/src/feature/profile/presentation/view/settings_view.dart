import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_controller.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/profile_provider.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  static const String _communitySupportEmail = 'vividxxxxx@gmail.com';
  static const Icon _trailingIcon = Icon(Icons.chevron_right);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final versionLabel = ref.watch(appVersionLabelProvider);
    final tenantRole = ref.watch(profileTenantRoleProvider);
    final canDeleteAccount = tenantRole.maybeWhen(
      data: _canDeleteAccount,
      orElse: () => false,
    );
    final deleteAccountSubtitle = tenantRole.maybeWhen(
      data: (role) => _canDeleteAccount(role)
          ? l10n.settingsDeleteAccountSubtitle
          : l10n.settingsDeleteAccountMemberOnly,
      orElse: () => l10n.settingsDeleteAccountSubtitle,
    );
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _buildMenuTile(
              leading: Icons.info_outline,
              title: l10n.settingsAppVersion,
              subtitle: versionLabel.maybeWhen(
                data: (value) => value,
                orElse: () => l10n.settingsVersionLoading,
              ),
              onTap: () => context.pushNamed(AppRoutes.appVersionName),
              trailing: _trailingIcon,
            ),
            const Divider(height: 1),
            _buildMenuTile(
              leading: Icons.description_outlined,
              title: l10n.settingsTermsOfService,
              onTap: () => context.pushNamed(AppRoutes.termsOfServiceName),
              trailing: _trailingIcon,
            ),
            const Divider(height: 1),
            _buildMenuTile(
              leading: Icons.privacy_tip_outlined,
              title: l10n.settingsPrivacyPolicy,
              onTap: () => context.pushNamed(AppRoutes.privacyPolicyName),
              trailing: _trailingIcon,
            ),
            const Divider(height: 1),
            _buildMenuTile(
              enabled: false,
              leading: Icons.support_agent_outlined,
              title: l10n.settingsCommunitySupport,
              subtitle: _communitySupportEmail,
            ),
            const Divider(height: 1),
            _buildMenuTile(
              enabled: canDeleteAccount && !isBusy,
              leading: Icons.delete_forever_outlined,
              title: l10n.settingsDeleteAccount,
              subtitle: deleteAccountSubtitle,
              onTap: !canDeleteAccount || isBusy
                  ? null
                  : () => _onDeleteAccountPressed(context, ref, l10n),
            ),
            const Divider(height: 1),
            _buildMenuTile(
              enabled: !isBusy,
              leading: Icons.logout,
              title: l10n.settingsSignOut,
              onTap: isBusy
                  ? null
                  : () => ref.read(authControllerProvider.notifier).signOut(),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  bool _canDeleteAccount(String? role) {
    return role == null || (role != 'coach' && role != 'owner');
  }

  ListTile _buildMenuTile({
    required IconData leading,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return ListTile(
      enabled: enabled,
      onTap: onTap,
      visualDensity: const VisualDensity(vertical: -1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      minLeadingWidth: 28,
      leading: Icon(leading, size: 20),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: trailing,
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
