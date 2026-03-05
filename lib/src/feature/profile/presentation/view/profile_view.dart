import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/profile_provider.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(authSessionProvider);
    final userEmail = session.asData?.value?.email ?? '-';
    final user = session.asData?.value;
    final fullName = ref.watch(profileFullNameProvider).asData?.value ?? '';
    final displayName = fullName.isEmpty
        ? (user?.userMetadata?['full_name'] as String?) ?? '-'
        : fullName;
    final avatarUrl = (user?.userMetadata?['avatar_url'] as String?) ?? '';

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
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: _ProfileHeader(
                name: displayName,
                email: userEmail,
                avatarUrl: avatarUrl,
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
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                onTap: () => context.pushNamed(AppRoutes.workoutRecordName),
                leading: const Icon(Icons.fitness_center_outlined),
                title: Text(l10n.profileWorkoutRecord),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  final String name;
  final String email;
  final String avatarUrl;

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
      ],
    );
  }
}
