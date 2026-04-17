import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/program_review/infra/entity/program_session_review_entity.dart';
import 'package:xontraining/src/feature/program_review/presentation/provider/program_session_review_provider.dart';

class CoachSessionReviewDetailView extends HookConsumerWidget {
  const CoachSessionReviewDetailView({required this.review, super.key});

  final CoachProgramSessionReviewEntity review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final feedbackController = useTextEditingController(
      text: review.review.normalizedCoachFeedback,
    );
    final controllerState = ref.watch(programSessionReviewControllerProvider);
    final isSaving = controllerState.isLoading;
    final dateLabel = DateFormat(
      'yyyy.MM.dd (E)',
      locale.languageCode,
    ).format(review.sessionDate);

    Future<void> save() async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      await ref
          .read(programSessionReviewControllerProvider.notifier)
          .reviewAsCoach(
            id: review.review.id,
            programId: review.review.programId,
            coachFeedback: feedbackController.text.trim(),
          );

      if (!context.mounted) {
        return;
      }

      final nextState = ref.read(programSessionReviewControllerProvider);
      if (nextState.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.programSessionReviewCoachSaveFailed)),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.programSessionReviewCoachSaved)),
      );
      Navigator.of(context).pop();
    }

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
                l10n.programSessionReviewCoachDetailTitle,
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
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Text(
                review.normalizedMemberName,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(review.normalizedProgramTitle),
              const SizedBox(height: 2),
              Text(
                '${review.normalizedSessionTitle} · $dateLabel',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.programSessionReviewMemberNoteLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Text(
                  review.review.normalizedCompletionNote,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.programSessionReviewCoachFeedbackLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: feedbackController,
                enabled: !isSaving,
                minLines: 5,
                maxLines: 7,
                maxLength: 300,
                decoration: InputDecoration(
                  hintText: l10n.programSessionReviewCoachFeedbackPlaceholder,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = (value ?? '').trim();
                  if (text.isEmpty) {
                    return l10n.programSessionReviewCoachFeedbackValidation;
                  }
                  if (text.length > 300) {
                    return l10n.programSessionReviewValidationMax;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: isSaving ? null : save,
                child: Text(
                  isSaving
                      ? l10n.profileSaving
                      : (review.review.isReviewed
                            ? l10n.programSessionReviewCoachUpdate
                            : l10n.programSessionReviewCoachSubmit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
