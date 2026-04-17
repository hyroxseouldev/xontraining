import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/infra/entity/program_detail_entity.dart';
import 'package:xontraining/src/feature/home/presentation/provider/program_detail_provider.dart';
import 'package:xontraining/src/feature/home/presentation/widget/week_calendar_selector.dart';
import 'package:xontraining/src/feature/program_review/infra/entity/program_session_review_entity.dart';
import 'package:xontraining/src/feature/program_review/presentation/provider/program_session_review_provider.dart';
import 'package:xontraining/src/feature/program_review/presentation/widget/session_review_editor_sheet.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class ProgramDetailView extends ConsumerStatefulWidget {
  const ProgramDetailView({
    required this.programId,
    this.program,
    this.firstDayOfWeek = WeekStartDay.monday,
    super.key,
  });

  final String programId;
  final ProgramEntity? program;
  final WeekStartDay firstDayOfWeek;

  @override
  ConsumerState<ProgramDetailView> createState() => _ProgramDetailViewState();
}

class _ProgramDetailViewState extends ConsumerState<ProgramDetailView> {
  late DateTime _selectedDate;
  late DateTime _visibleWeekAnchorDate;

  @override
  void initState() {
    super.initState();
    final today = _dateOnly(DateTime.now());
    _selectedDate = today;
    _visibleWeekAnchorDate = today;
  }

  void _goToToday() {
    final today = _dateOnly(DateTime.now());
    setState(() {
      _selectedDate = today;
      _visibleWeekAnchorDate = today;
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _visibleWeekAnchorDate = date;
    });
  }

  void _showPreviousWeek() {
    setState(() {
      _visibleWeekAnchorDate = _visibleWeekAnchorDate.subtract(
        const Duration(days: 7),
      );
    });
  }

  void _showNextWeek() {
    setState(() {
      _visibleWeekAnchorDate = _visibleWeekAnchorDate.add(
        const Duration(days: 7),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.program?.title ?? l10n.homeProgramDetailTitle;
    final detailState = ref.watch(
      programDetailPayloadProvider(widget.programId),
    );
    final reviewState = ref.watch(
      myProgramSessionReviewsProvider(programId: widget.programId),
    );
    final isTodaySelected = DateUtils.isSameDay(_selectedDate, DateTime.now());
    final showGoTodayAction = detailState.maybeWhen(
      data: (payload) => payload.canAccess && payload.sessions.isNotEmpty,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        actions: [
          if (showGoTodayAction)
            TextButton.icon(
              onPressed: isTodaySelected ? null : _goToToday,
              icon: const Icon(Icons.today_outlined, size: 18),
              label: Text(l10n.homeProgramDetailToday),
            ),
          TextButton.icon(
            onPressed: () {
              context.pushNamed(
                AppRoutes.programCoachName,
                pathParameters: {'programId': widget.programId},
              );
            },
            icon: const Icon(Icons.person_outline, size: 18),
            label: Text(l10n.homeCoachInfoAction),
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                title,
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
      body: detailState.when(
        loading: () => const _ProgramDetailLoadingSkeleton(),
        error: (error, stackTrace) => EmptyState(message: l10n.homeLoadFailed),
        data: (payload) {
          if (!payload.canAccess) {
            return EmptyState(
              message: l10n.homeProgramDetailPurchaseRequired,
              icon: Icons.lock_outline,
            );
          }
          if (payload.sessions.isEmpty) {
            return EmptyState(
              message: l10n.homeProgramDetailNoSessions,
              icon: Icons.event_busy_outlined,
            );
          }

          return _ProgramSessionContent(
            programId: widget.programId,
            sessions: payload.sessions,
            sessionReviewsBySessionId: reviewState.asData?.value ?? const {},
            isReviewLoading: reviewState.isLoading,
            hasReviewLoadError: reviewState.hasError,
            firstDayOfWeek: widget.firstDayOfWeek,
            selectedDate: _selectedDate,
            visibleWeekAnchorDate: _visibleWeekAnchorDate,
            onDateSelected: _selectDate,
            onPreviousWeek: _showPreviousWeek,
            onNextWeek: _showNextWeek,
          );
        },
      ),
    );
  }
}

class _ProgramDetailLoadingSkeleton extends StatelessWidget {
  const _ProgramDetailLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _ShimmerBox(height: 88),
          SizedBox(height: 14),
          _ShimmerBox(height: 24, width: 210),
          SizedBox(height: 10),
          _ShimmerBox(height: 16, width: 150),
          SizedBox(height: 18),
          _ShimmerBox(height: 18),
          SizedBox(height: 8),
          _ShimmerBox(height: 18),
          SizedBox(height: 8),
          _ShimmerBox(height: 18, width: 260),
          SizedBox(height: 18),
          _ShimmerBox(height: 18),
          SizedBox(height: 8),
          _ShimmerBox(height: 18, width: 230),
        ],
      ),
    );
  }
}

class _ProgramSessionContent extends ConsumerWidget {
  const _ProgramSessionContent({
    required this.programId,
    required this.sessions,
    required this.sessionReviewsBySessionId,
    required this.isReviewLoading,
    required this.hasReviewLoadError,
    required this.firstDayOfWeek,
    required this.selectedDate,
    required this.visibleWeekAnchorDate,
    required this.onDateSelected,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  final String programId;
  final List<ProgramSessionEntity> sessions;
  final Map<String, ProgramSessionReviewEntity> sessionReviewsBySessionId;
  final bool isReviewLoading;
  final bool hasReviewLoadError;
  final WeekStartDay firstDayOfWeek;
  final DateTime selectedDate;
  final DateTime visibleWeekAnchorDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionDates = sessions
        .map((session) => _dateOnly(session.sessionDate))
        .toSet();
    final restDates = sessions
        .where((session) => session.isRest)
        .map((session) => _dateOnly(session.sessionDate))
        .toSet();
    final scheduledDates = sessions
        .where((session) => session.isScheduled)
        .map((session) => _dateOnly(session.sessionDate))
        .toSet();

    final selectedSession = _sessionForSelectedDateOrNull(
      sessions,
      selectedDate,
    );
    final selectedReview = selectedSession == null
        ? null
        : sessionReviewsBySessionId[selectedSession.id];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: WeekCalendarSelector(
            visibleWeekAnchorDate: visibleWeekAnchorDate,
            selectedDate: selectedDate,
            enabledDates: sessionDates,
            restDates: restDates,
            scheduledDates: scheduledDates,
            firstDayOfWeek: firstDayOfWeek,
            onDateSelected: onDateSelected,
            onPreviousWeek: onPreviousWeek,
            onNextWeek: onNextWeek,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: selectedSession == null
              ? EmptyState(
                  message: l10n.homeProgramDetailNoSessionForSelectedDate,
                  icon: Icons.event_note_outlined,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedSession.normalizedTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            if (selectedSession.isRest)
                              _SessionTypeChip(
                                label: l10n.homeProgramDetailSessionTypeRest,
                                icon: Icons.self_improvement_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                                onColor: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            if (selectedSession.isScheduled)
                              _SessionTypeChip(
                                label: l10n.homeProgramDetailScheduled,
                                icon: Icons.lock_clock_outlined,
                                color: Theme.of(context).colorScheme.tertiary,
                                onColor: Theme.of(
                                  context,
                                ).colorScheme.onTertiary,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _sessionMetaText(
                            context: context,
                            session: selectedSession,
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 14),
                        if (selectedSession.isScheduled)
                          _ScheduledSessionMessage(session: selectedSession)
                        else if (selectedSession.isRest)
                          _RestSessionMessage(session: selectedSession)
                        else ...[
                          _SessionHtmlRenderer(
                            html: selectedSession.normalizedContentHtml,
                          ),
                          const SizedBox(height: 16),
                          _ProgramSessionReviewSection(
                            programId: programId,
                            session: selectedSession,
                            review: selectedReview,
                            isLoading: isReviewLoading,
                            hasLoadError: hasReviewLoadError,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ProgramSessionReviewSection extends ConsumerWidget {
  const _ProgramSessionReviewSection({
    required this.programId,
    required this.session,
    required this.review,
    required this.isLoading,
    required this.hasLoadError,
  });

  final String programId;
  final ProgramSessionEntity session;
  final ProgramSessionReviewEntity? review;
  final bool isLoading;
  final bool hasLoadError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    Future<void> openEditor() async {
      final result = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return SessionReviewEditorSheet(
            programId: programId,
            session: session,
            review: review,
          );
        },
      );

      if (result != true || !context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            review == null
                ? l10n.programSessionReviewSubmitted
                : l10n.programSessionReviewUpdated,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.programSessionReviewSectionTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (review != null) _ReviewStatusBadge(review: review!),
            ],
          ),
          const SizedBox(height: 8),
          if (isLoading && review == null)
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(l10n.programSessionReviewLoading)),
              ],
            )
          else if (hasLoadError && review == null) ...[
            Text(l10n.programSessionReviewLoadFailed),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.invalidate(
                  myProgramSessionReviewsProvider(programId: programId),
                );
              },
              child: Text(l10n.programSessionReviewRetry),
            ),
          ] else if (review == null) ...[
            Text(
              l10n.programSessionReviewEmptyDescription,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: openEditor,
              icon: const Icon(Icons.rate_review_outlined),
              label: Text(l10n.programSessionReviewCreateAction),
            ),
          ] else ...[
            Text(
              review!.normalizedCompletionNote,
              style: theme.textTheme.bodyMedium,
            ),
            if (review!.isReviewed && review!.hasCoachFeedback) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _CoachFeedbackAvatar(review: review!),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review!.normalizedReviewerName,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.programSessionReviewCoachFeedbackLabel,
                                style: theme.textTheme.bodySmall?.copyWith(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      review!.normalizedCoachFeedback,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            if (review!.canEditByMember)
              OutlinedButton.icon(
                onPressed: openEditor,
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.programSessionReviewEditAction),
              )
            else
              Text(
                l10n.programSessionReviewLockedDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _CoachFeedbackAvatar extends StatelessWidget {
  const _CoachFeedbackAvatar({required this.review});

  final ProgramSessionReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = CircleAvatar(
      radius: 20,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.person,
        size: 20,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );

    if (!review.hasReviewerAvatarUrl) {
      return fallback;
    }

    return ClipOval(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CachedNetworkImage(
          imageUrl: review.normalizedReviewerAvatarUrl,
          fit: BoxFit.cover,
          placeholder: (context, imageUrl) => fallback,
          errorWidget: (context, imageUrl, error) => fallback,
        ),
      ),
    );
  }
}

class _ReviewStatusBadge extends StatelessWidget {
  const _ReviewStatusBadge({required this.review});

  final ProgramSessionReviewEntity review;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isReviewed = review.isReviewed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isReviewed
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isReviewed
            ? l10n.programSessionReviewStatusReviewed
            : l10n.programSessionReviewStatusSubmitted,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

ProgramSessionEntity? _sessionForSelectedDateOrNull(
  List<ProgramSessionEntity> sessions,
  DateTime selectedDate,
) {
  for (final session in sessions) {
    if (DateUtils.isSameDay(session.sessionDate, selectedDate)) {
      return session;
    }
  }
  return null;
}

String _sessionMetaText({
  required BuildContext context,
  required ProgramSessionEntity session,
}) {
  final locale = Localizations.localeOf(context);
  final dateText = DateFormat('yyyy.MM.dd').format(session.sessionDate);
  final dayText = DateFormat(
    'E',
    locale.languageCode,
  ).format(session.sessionDate);
  return '$dateText ($dayText)';
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

class _SessionHtmlRenderer extends StatelessWidget {
  const _SessionHtmlRenderer({required this.html});

  final String html;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.bodyLarge;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return Html(
      data: html,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          lineHeight: const LineHeight(1.5),
          letterSpacing: 0,
          fontSize: bodyStyle != null
              ? FontSize(bodyStyle.fontSize ?? 16)
              : null,
          fontWeight: bodyStyle?.fontWeight,
          color: bodyStyle?.color,
        ),
        'p': Style(margin: Margins.only(bottom: 6)),
        'div': Style(margin: Margins.only(bottom: 6)),
        'ul': Style(
          margin: Margins.only(bottom: 4),
          padding: HtmlPaddings.only(left: 14),
        ),
        'ol': Style(
          margin: Margins.only(bottom: 4),
          padding: HtmlPaddings.only(left: 14),
        ),
        'li': Style(margin: Margins.only(bottom: 2)),
        'h1': Style(
          margin: Margins.only(top: 2, bottom: 6),
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          lineHeight: const LineHeight(1.35),
          fontSize: titleStyle != null
              ? FontSize(titleStyle.fontSize ?? 16)
              : null,
        ),
        'h2': Style(
          margin: Margins.only(top: 2, bottom: 6),
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          lineHeight: const LineHeight(1.35),
          fontSize: titleStyle != null
              ? FontSize(titleStyle.fontSize ?? 16)
              : null,
        ),
        'h3': Style(
          margin: Margins.only(top: 2, bottom: 6),
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          lineHeight: const LineHeight(1.35),
          fontSize: titleStyle != null
              ? FontSize(titleStyle.fontSize ?? 16)
              : null,
        ),
      },
      onLinkTap: (url, attributes, element) async {
        final href = url?.trim();
        if (href == null || href.isEmpty) {
          return;
        }
        final uri = Uri.tryParse(href);
        if (uri == null) {
          return;
        }
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
    );
  }
}

class _SessionTypeChip extends StatelessWidget {
  const _SessionTypeChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: onColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: onColor),
          ),
        ],
      ),
    );
  }
}

class _ScheduledSessionMessage extends StatelessWidget {
  const _ScheduledSessionMessage({required this.session});

  final ProgramSessionEntity session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final publishAt = session.publishAt;
    final message = publishAt == null
        ? l10n.homeProgramDetailScheduledDescription
        : l10n.homeProgramDetailScheduledAt(
            _formatPublishAt(context, publishAt),
          );

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_clock_outlined, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _RestSessionMessage extends StatelessWidget {
  const _RestSessionMessage({required this.session});

  final ProgramSessionEntity session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.self_improvement_outlined, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.homeProgramDetailRestDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        if (session.normalizedContentHtml.isNotEmpty) ...[
          const SizedBox(height: 12),
          _SessionHtmlRenderer(html: session.normalizedContentHtml),
        ],
      ],
    );
  }
}

String _formatPublishAt(BuildContext context, DateTime value) {
  final locale = Localizations.localeOf(context);
  return DateFormat(
    'yyyy.MM.dd HH:mm',
    locale.languageCode,
  ).format(value.toLocal());
}

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox({this.height, this.width});

  final double? height;
  final double? width;

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlightColor = Theme.of(context).colorScheme.surfaceContainer;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final shimmerX = (width * 2 * _controller.value) - width;

              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(color: baseColor),
                    Transform.translate(
                      offset: Offset(shimmerX, 0),
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              baseColor.withValues(alpha: 0),
                              highlightColor.withValues(alpha: 0.9),
                              baseColor.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
