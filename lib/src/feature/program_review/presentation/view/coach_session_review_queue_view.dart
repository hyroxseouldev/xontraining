import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/program_review/infra/entity/program_session_review_entity.dart';
import 'package:xontraining/src/feature/program_review/presentation/provider/program_session_review_provider.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class CoachSessionReviewQueueView extends HookConsumerWidget {
  const CoachSessionReviewQueueView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedStatus = useState(ProgramSessionReviewStatus.submitted);
    final reviewsState = ref.watch(
      coachProgramSessionReviewsProvider(status: selectedStatus.value),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.programSessionReviewCoachQueueTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(l10n.programSessionReviewStatusSubmitted),
                      selected:
                          selectedStatus.value ==
                          ProgramSessionReviewStatus.submitted,
                      onSelected: (_) {
                        selectedStatus.value =
                            ProgramSessionReviewStatus.submitted;
                      },
                    ),
                    ChoiceChip(
                      label: Text(l10n.programSessionReviewStatusReviewed),
                      selected:
                          selectedStatus.value ==
                          ProgramSessionReviewStatus.reviewed,
                      onSelected: (_) {
                        selectedStatus.value =
                            ProgramSessionReviewStatus.reviewed;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: reviewsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            EmptyState(message: l10n.programSessionReviewCoachQueueLoadFailed),
        data: (reviews) {
          if (reviews.isEmpty) {
            return EmptyState(
              message:
                  selectedStatus.value == ProgramSessionReviewStatus.submitted
                  ? l10n.programSessionReviewCoachQueueEmptySubmitted
                  : l10n.programSessionReviewCoachQueueEmptyReviewed,
              icon: Icons.mark_chat_read_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: reviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _CoachReviewCard(review: review);
            },
          );
        },
      ),
    );
  }
}

class _CoachReviewCard extends StatelessWidget {
  const _CoachReviewCard({required this.review});

  final CoachProgramSessionReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final dateLabel = DateFormat(
      'yyyy.MM.dd',
      locale.languageCode,
    ).format(review.sessionDate);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.pushNamed(
          AppRoutes.coachSessionReviewDetailName,
          pathParameters: {'reviewId': review.review.id},
          extra: review,
        );
      },
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    review.normalizedMemberName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StatusChip(status: review.review.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.normalizedProgramTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 2),
            Text(
              '${review.normalizedSessionTitle} · $dateLabel',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              review.review.normalizedCompletionNote,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (review.review.hasCoachFeedback) ...[
              const SizedBox(height: 12),
              Text(
                l10n.programSessionReviewCoachFeedbackLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                review.review.normalizedCoachFeedback,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ProgramSessionReviewStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isReviewed = status == ProgramSessionReviewStatus.reviewed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isReviewed
            ? colorScheme.secondaryContainer
            : colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isReviewed
            ? l10n.programSessionReviewStatusReviewed
            : l10n.programSessionReviewStatusSubmitted,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
