import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/home/infra/entity/coach_info_entity.dart';
import 'package:xontraining/src/feature/home/presentation/provider/program_detail_provider.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class ProgramCoachView extends HookConsumerWidget {
  const ProgramCoachView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final coachInfoState = ref.watch(coachInfoProvider);

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
                l10n.homeCoachInfoTitle,
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
      body: coachInfoState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => EmptyState(message: l10n.homeLoadFailed),
        data: (coachInfo) {
          if (coachInfo == null) {
            return EmptyState(
              message: l10n.homeCoachInfoEmpty,
              icon: Icons.person_off_outlined,
            );
          }

          return _CoachInfoContent(coachInfo: coachInfo);
        },
      ),
    );
  }
}

class _CoachInfoContent extends StatelessWidget {
  const _CoachInfoContent({required this.coachInfo});

  final CoachInfoEntity coachInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: [
        if (coachInfo.hasImageUrl)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 1,
              child: CachedNetworkImage(
                imageUrl: coachInfo.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, imageUrl) {
                  return Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorWidget: (context, imageUrl, error) {
                  return Container(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image_outlined),
                  );
                },
              ),
            ),
          ),
        if (coachInfo.hasImageUrl) const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(84),
                1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              children: [
                _tableRow(
                  context: context,
                  label: l10n.homeCoachInfoName,
                  child: Text(
                    coachInfo.name.isEmpty
                        ? l10n.homeProgramValueNotAvailable
                        : coachInfo.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _tableRow(
                  context: context,
                  label: l10n.homeCoachInfoCareer,
                  child: _careerWidget(context, coachInfo.career),
                ),
                _tableRow(
                  context: context,
                  label: l10n.homeCoachInfoInstagram,
                  child: _instagramWidget(context, coachInfo.instagram),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TableRow _tableRow({
    required BuildContext context,
    required String label,
    required Widget child,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: child),
      ],
    );
  }

  Widget _careerWidget(BuildContext context, List<String> career) {
    final l10n = AppLocalizations.of(context)!;
    if (career.isEmpty) {
      return Text(l10n.homeProgramValueNotAvailable);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: career
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• $item'),
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _instagramWidget(BuildContext context, String instagram) {
    final l10n = AppLocalizations.of(context)!;
    final normalized = instagram.trim();
    if (normalized.isEmpty) {
      return Text(l10n.homeProgramValueNotAvailable);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton.filledTonal(
        onPressed: () => _openInstagram(context, normalized),
        tooltip: l10n.homeCoachInfoInstagram,
        icon: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }

  Future<void> _openInstagram(BuildContext context, String rawValue) async {
    final l10n = AppLocalizations.of(context)!;
    final value = rawValue.trim();
    final url = value.startsWith('http')
        ? value
        : 'https://instagram.com/${value.replaceAll('@', '')}';
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeCoachInfoInstagramOpenFailed)),
      );
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted || opened) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.homeCoachInfoInstagramOpenFailed)),
    );
  }
}
