import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/auth/presentation/provider/auth_session_provider.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/presentation/provider/home_controller.dart';
import 'package:xontraining/src/feature/home/presentation/widget/blueprint_section_card.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(authSessionProvider);
    final userEmail = session.asData?.value?.email ?? '-';
    final homeState = ref.watch(homeControllerProvider);

    ref.listen<AsyncValue<HomeState>>(homeControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.homeLoadFailed)));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pushNamed(AppRoutes.profileName),
          icon: const Icon(Icons.person_outline),
          tooltip: l10n.homeProfile,
        ),
        actions: [],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(
              l10n.homeTitle,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          homeState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text(l10n.homeLoadFailed)),
            data: (data) {
              final activeProgram = data.activeProgram;

              if (activeProgram == null) {
                return EmptyState(
                  message: l10n.homeNoActiveProgram,
                  icon: Icons.event_busy_outlined,
                );
              }

              final formattedDate = MaterialLocalizations.of(
                context,
              ).formatMediumDate(data.selectedDate);

              return SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      l10n.homeCurrentProgram,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activeProgram.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if ((activeProgram.shortDescription ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(activeProgram.shortDescription!),
                    ],
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _selectDate(
                        context: context,
                        ref: ref,
                        initialDate: data.selectedDate,
                      ),
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(l10n.homeScheduleForDate(formattedDate)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.homeSignedInAs(userEmail),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    if (data.sections.isEmpty)
                      EmptyState(
                        message: l10n.homeNoScheduleForDate,
                        icon: Icons.calendar_month_outlined,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                      )
                    else
                      ...data.sections.map(
                        (section) => BlueprintSectionCard(section: section),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate({
    required BuildContext context,
    required WidgetRef ref,
    required DateTime initialDate,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
    );

    if (picked == null) {
      return;
    }

    await ref.read(homeControllerProvider.notifier).selectDate(picked);
  }
}
