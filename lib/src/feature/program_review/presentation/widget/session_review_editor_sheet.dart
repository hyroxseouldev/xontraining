import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/home/infra/entity/program_detail_entity.dart';
import 'package:xontraining/src/feature/program_review/infra/entity/program_session_review_entity.dart';
import 'package:xontraining/src/feature/program_review/presentation/provider/program_session_review_provider.dart';

class SessionReviewEditorSheet extends HookConsumerWidget {
  const SessionReviewEditorSheet({
    required this.programId,
    required this.session,
    this.review,
    super.key,
  });

  final String programId;
  final ProgramSessionEntity session;
  final ProgramSessionReviewEntity? review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final noteController = useTextEditingController(
      text: review?.normalizedCompletionNote ?? '',
    );
    final controllerState = ref.watch(programSessionReviewControllerProvider);
    final isSubmitting = controllerState.isLoading;
    final dateLabel = DateFormat(
      'yyyy.MM.dd (E)',
      locale.languageCode,
    ).format(session.sessionDate);

    Future<void> submit() async {
      if (formKey.currentState?.validate() != true) {
        return;
      }

      final note = noteController.text.trim();
      if (review == null) {
        await ref
            .read(programSessionReviewControllerProvider.notifier)
            .submitMyReview(
              programId: programId,
              sessionId: session.id,
              completionNote: note,
            );
      } else {
        await ref
            .read(programSessionReviewControllerProvider.notifier)
            .updateMyReview(
              id: review!.id,
              programId: programId,
              completionNote: note,
            );
      }

      if (!context.mounted) {
        return;
      }

      final nextState = ref.read(programSessionReviewControllerProvider);
      if (nextState.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.programSessionReviewSubmitFailed)),
        );
        return;
      }

      Navigator.of(context).pop(true);
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review == null
                  ? l10n.programSessionReviewCreateTitle
                  : l10n.programSessionReviewEditTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              session.normalizedTitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              dateLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.programSessionReviewEditorHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: noteController,
              enabled: !isSubmitting,
              minLines: 6,
              maxLines: 8,
              maxLength: 300,
              decoration: InputDecoration(
                hintText: l10n.programSessionReviewEditorPlaceholder,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                final text = (value ?? '').trim();
                if (text.length < 10) {
                  return l10n.programSessionReviewValidationMin;
                }
                if (text.length > 300) {
                  return l10n.programSessionReviewValidationMax;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(false),
                    child: Text(l10n.programSessionReviewCancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: isSubmitting ? null : submit,
                    child: Text(
                      isSubmitting
                          ? l10n.profileSaving
                          : (review == null
                                ? l10n.programSessionReviewSubmit
                                : l10n.programSessionReviewUpdate),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
