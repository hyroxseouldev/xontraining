import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/presentation/provider/home_controller.dart';
import 'package:xontraining/src/feature/home/presentation/widget/program_list_item.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final homeState = ref.watch(homeControllerProvider);

    ref.listen<AsyncValue<List<ProgramEntity>>>(homeControllerProvider, (
      previous,
      next,
    ) {
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
        title: Text(l10n.homeProgramsTitle),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.profileName),
            icon: const Icon(Icons.person_outline),
            tooltip: l10n.homeProfile,
          ),
        ],
      ),
      body: homeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => EmptyState(message: l10n.homeLoadFailed),
        data: (programs) {
          if (programs.isEmpty) {
            return EmptyState(
              message: l10n.homeNoPrograms,
              icon: Icons.event_busy_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: programs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return ProgramListItem(program: programs[index]);
            },
          );
        },
      ),
    );
  }
}
