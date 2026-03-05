import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/profile/presentation/provider/legal_document_provider.dart';
import 'package:xontraining/src/feature/profile/presentation/widget/legal_document_renderer.dart';

class TermsOfServiceView extends ConsumerWidget {
  const TermsOfServiceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final documentState = ref.watch(termsDocumentProvider);

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
                l10n.settingsTermsOfService,
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
        child: documentState.when(
          data: (document) => LegalDocumentRenderer(document: document),
          loading: () => Center(child: Text(l10n.legalDocumentLoading)),
          error: (error, stackTrace) =>
              Center(child: Text(l10n.legalDocumentLoadFailed)),
        ),
      ),
    );
  }
}
