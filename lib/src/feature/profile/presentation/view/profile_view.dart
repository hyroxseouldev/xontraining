import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';
import 'package:xontraining/src/feature/profile/infra/entity/profile_entity.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/profile_provider.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  static const Icon _trailingIcon = Icon(Icons.chevron_right);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(authSessionProvider);
    final userEmail = session.asData?.value?.email ?? '-';
    final profile = ref.watch(profileProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.settingsName),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.profileSettings,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                l10n.profileTitle,
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
            Center(
              child: _ProfileHeader(
                name: profile?.displayName ?? '-',
                email: userEmail,
                avatarUrl: profile?.displayAvatarUrl ?? '',
                genderLabel:
                    '${l10n.profileGenderLabel}: ${_genderLabel(l10n, profile?.gender)}',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.pushNamed(AppRoutes.profileEditName),
              child: Text(l10n.profileEdit),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.profileMenuTitle,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildMenuTile(
              leading: Icons.fitness_center_outlined,
              title: l10n.profileWorkoutRecord,
              trailing: _trailingIcon,
              onTap: () => context.pushNamed(AppRoutes.workoutRecordName),
            ),
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  String _genderLabel(AppLocalizations l10n, ProfileGender? gender) {
    return switch (gender) {
      ProfileGender.male => l10n.genderMale,
      ProfileGender.female => l10n.genderFemale,
      ProfileGender.other => l10n.genderOther,
      ProfileGender.preferNotToSay => l10n.genderPreferNotToSay,
      null => '-',
    };
  }

  ListTile _buildMenuTile({
    required IconData leading,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      visualDensity: const VisualDensity(vertical: -1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      minLeadingWidth: 28,
      leading: Icon(leading, size: 20),
      title: Text(title),
      trailing: trailing,
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.genderLabel,
  });

  final String name;
  final String email;
  final String avatarUrl;
  final String genderLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 96,
          height: 96,
          child: avatarUrl.isEmpty
              ? CircleAvatar(
                  radius: 48,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainer,
                  child: Icon(
                    Icons.person,
                    size: 44,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              : ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: avatarUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, imageUrl) {
                      return CircleAvatar(
                        radius: 48,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                        child: Icon(
                          Icons.person,
                          size: 44,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                    errorWidget: (context, imageUrl, error) {
                      return CircleAvatar(
                        radius: 48,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                        child: Icon(
                          Icons.person,
                          size: 44,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(email, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text(genderLabel, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
