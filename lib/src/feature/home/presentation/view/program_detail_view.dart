import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/core/router/app_router.dart';
import 'package:xontraining/src/feature/home/infra/entity/home_entity.dart';
import 'package:xontraining/src/feature/home/infra/entity/program_detail_entity.dart';
import 'package:xontraining/src/feature/home/presentation/provider/program_detail_provider.dart';
import 'package:xontraining/src/feature/home/presentation/widget/week_calendar_selector.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class ProgramDetailView extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title = program?.title ?? l10n.homeProgramDetailTitle;
    final detailState = ref.watch(programDetailPayloadProvider(programId));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        actions: [
          TextButton.icon(
            onPressed: () {
              context.pushNamed(
                AppRoutes.programCoachName,
                pathParameters: {'programId': programId},
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
            sessions: payload.sessions,
            firstDayOfWeek: firstDayOfWeek,
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

class _ProgramSessionContent extends StatefulWidget {
  const _ProgramSessionContent({
    required this.sessions,
    required this.firstDayOfWeek,
  });

  final List<ProgramSessionEntity> sessions;
  final WeekStartDay firstDayOfWeek;

  @override
  State<_ProgramSessionContent> createState() => _ProgramSessionContentState();
}

class _ProgramSessionContentState extends State<_ProgramSessionContent> {
  late DateTime _selectedDate;
  late DateTime _visibleWeekAnchorDate;

  @override
  void initState() {
    super.initState();
    final today = _dateOnly(DateTime.now());
    _selectedDate = today;
    _visibleWeekAnchorDate = today;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessionDates = widget.sessions
        .map((session) => _dateOnly(session.sessionDate))
        .toSet();

    final selectedSession = _sessionForSelectedDateOrNull(
      widget.sessions,
      _selectedDate,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: WeekCalendarSelector(
            visibleWeekAnchorDate: _visibleWeekAnchorDate,
            selectedDate: _selectedDate,
            enabledDates: sessionDates,
            firstDayOfWeek: widget.firstDayOfWeek,
            todayButtonLabel: l10n.homeProgramDetailToday,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _visibleWeekAnchorDate = date;
              });
            },
            onGoToday: () {
              final today = _dateOnly(DateTime.now());
              setState(() {
                _selectedDate = today;
                _visibleWeekAnchorDate = today;
              });
            },
            onPreviousWeek: () {
              setState(() {
                _visibleWeekAnchorDate = _visibleWeekAnchorDate.subtract(
                  const Duration(days: 7),
                );
              });
            },
            onNextWeek: () {
              setState(() {
                _visibleWeekAnchorDate = _visibleWeekAnchorDate.add(
                  const Duration(days: 7),
                );
              });
            },
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedSession.normalizedTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _sessionMetaText(
                          context: context,
                          session: selectedSession,
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _toPlainText(selectedSession.normalizedContentHtml),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
        ),
      ],
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

String _toPlainText(String html) {
  var text = html;
  text = text.replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), '\n');
  text = text.replaceAll(RegExp(r'<\s*li[^>]*>', caseSensitive: false), '• ');
  text = text.replaceAll(
    RegExp(
      r'</\s*(p|div|h1|h2|h3|h4|h5|h6|li|ul|ol)\s*>',
      caseSensitive: false,
    ),
    '\n',
  );
  text = text.replaceAll(RegExp(r'<[^>]*>'), '');
  text = text
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'");
  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  return text.trim();
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
