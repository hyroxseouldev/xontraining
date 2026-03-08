import 'package:flutter/material.dart';

enum WeekStartDay { monday, sunday }

class WeekCalendarSelector extends StatelessWidget {
  const WeekCalendarSelector({
    required this.visibleWeekAnchorDate,
    required this.selectedDate,
    required this.enabledDates,
    required this.restDates,
    required this.scheduledDates,
    required this.firstDayOfWeek,
    required this.onDateSelected,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onGoToday,
    required this.todayButtonLabel,
    super.key,
  });

  final DateTime visibleWeekAnchorDate;
  final DateTime selectedDate;
  final Set<DateTime> enabledDates;
  final Set<DateTime> restDates;
  final Set<DateTime> scheduledDates;
  final WeekStartDay firstDayOfWeek;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onGoToday;
  final String todayButtonLabel;

  @override
  Widget build(BuildContext context) {
    final weekStart = _startOfWeek(visibleWeekAnchorDate, firstDayOfWeek);
    final weekDates = List<DateTime>.generate(
      7,
      (index) => _dateOnly(weekStart.add(Duration(days: index))),
    );
    final dateFormatter = MaterialLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: onGoToday, child: Text(todayButtonLabel)),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: onPreviousWeek,
              icon: const Icon(Icons.chevron_left),
            ),

            Expanded(
              child: Text(
                _weekRangeLabel(
                  context: context,
                  start: weekDates.first,
                  end: weekDates.last,
                ),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              onPressed: onNextWeek,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: weekDates
              .map((date) {
                final dayLabel = _weekdayLabel(
                  localizations: dateFormatter,
                  date: date,
                );
                final isSelected = DateUtils.isSameDay(selectedDate, date);
                final isEnabled = enabledDates.contains(_dateOnly(date));
                final isToday = DateUtils.isSameDay(DateTime.now(), date);
                final isRest = restDates.contains(_dateOnly(date));
                final isScheduled = scheduledDates.contains(_dateOnly(date));

                return Expanded(
                  child: _DayCell(
                    dayLabel: dayLabel,
                    dayNumber: date.day,
                    isSelected: isSelected,
                    isEnabled: isEnabled,
                    isToday: isToday,
                    isRest: isRest,
                    isScheduled: isScheduled,
                    onTap: () => onDateSelected(date),
                  ),
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.dayLabel,
    required this.dayNumber,
    required this.isSelected,
    required this.isEnabled,
    required this.isToday,
    required this.isRest,
    required this.isScheduled,
    required this.onTap,
  });

  final String dayLabel;
  final int dayNumber;
  final bool isSelected;
  final bool isEnabled;
  final bool isToday;
  final bool isRest;
  final bool isScheduled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedBackground = colorScheme.primaryContainer;
    final selectedTextColor = colorScheme.onPrimaryContainer;

    late final Color backgroundColor;
    Color textColor = colorScheme.onSurface;

    if (isSelected) {
      backgroundColor = selectedBackground;
      textColor = selectedTextColor;
    } else if (!isEnabled) {
      backgroundColor = colorScheme.surface;
      textColor = colorScheme.onSurface;
    } else if (isToday) {
      backgroundColor = colorScheme.surfaceContainerHigh;
      textColor = colorScheme.onSurface;
    } else {
      backgroundColor = colorScheme.surfaceContainerHighest;
      textColor = colorScheme.onSurface;
    }

    final hasSessionInfo = isRest || isScheduled;

    final markerColor = isScheduled
        ? colorScheme.tertiary
        : isRest
        ? colorScheme.secondary
        : colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          height: 64,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: textColor),
              ),
              const SizedBox(height: 6),
              Text(
                '$dayNumber',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              hasSessionInfo
                  ? Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isEnabled
                            ? markerColor
                            : markerColor.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                    )
                  : const SizedBox(width: 6, height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

DateTime startOfWeek(DateTime date, WeekStartDay firstDayOfWeek) {
  return _startOfWeek(date, firstDayOfWeek);
}

DateTime _startOfWeek(DateTime date, WeekStartDay firstDayOfWeek) {
  final normalized = _dateOnly(date);
  final weekday = normalized.weekday;
  final offset = firstDayOfWeek == WeekStartDay.monday
      ? weekday - DateTime.monday
      : weekday % 7;
  return _dateOnly(normalized.subtract(Duration(days: offset)));
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

String _weekRangeLabel({
  required BuildContext context,
  required DateTime start,
  required DateTime end,
}) {
  final localizations = MaterialLocalizations.of(context);
  return '${localizations.formatShortDate(start)} - ${localizations.formatShortDate(end)}';
}

String _weekdayLabel({
  required MaterialLocalizations localizations,
  required DateTime date,
}) {
  final labels = localizations.narrowWeekdays;
  final index = date.weekday % 7;
  return labels[index];
}
