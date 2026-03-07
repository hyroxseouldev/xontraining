import 'package:html/parser.dart' as html_parser;
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/community/infra/entity/community_entity.dart';

String communityHtmlToPlainText(String html) {
  final text = html_parser.parseFragment(html).text ?? '';
  final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  return normalized;
}

String buildCommunityTimeAgo({
  required DateTime createdAt,
  required DateTime now,
  required AppLocalizations l10n,
}) {
  final diff = now.toUtc().difference(createdAt.toUtc());
  if (diff.inSeconds < 60) {
    return l10n.communityTimeAgoSeconds(diff.inSeconds);
  }
  if (diff.inMinutes < 60) {
    return l10n.communityTimeAgoMinutes(diff.inMinutes);
  }
  if (diff.inHours < 24) {
    return l10n.communityTimeAgoHours(diff.inHours);
  }
  if (diff.inDays < 7) {
    return l10n.communityTimeAgoDays(diff.inDays);
  }
  return l10n.communityTimeAgoWeeks((diff.inDays / 7).floor());
}

String buildCommunityDateTimeLabel({
  required DateTime createdAt,
  required DateTime now,
  required AppLocalizations l10n,
  required bool isCreatedToday,
  required String englishDateLabel,
  required String timeLabel24h,
}) {
  if (isCreatedToday) {
    final timeAgo = buildCommunityTimeAgo(
      createdAt: createdAt,
      now: now,
      l10n: l10n,
    );
    return '$englishDateLabel · $timeAgo';
  }

  return '$englishDateLabel · $timeLabel24h';
}

String buildCommunityPostDateTimeLabel({
  required CommunityPostEntity post,
  required DateTime now,
  required AppLocalizations l10n,
}) {
  return buildCommunityDateTimeLabel(
    createdAt: post.createdAt,
    now: now,
    l10n: l10n,
    isCreatedToday: post.isCreatedToday(now),
    englishDateLabel: post.createdAtEnglishDateLabel,
    timeLabel24h: post.createdAtTimeLabel24h,
  );
}

String buildCommunityCommentDateTimeLabel({
  required CommunityCommentEntity comment,
  required DateTime now,
  required AppLocalizations l10n,
}) {
  return buildCommunityDateTimeLabel(
    createdAt: comment.createdAt,
    now: now,
    l10n: l10n,
    isCreatedToday: comment.isCreatedToday(now),
    englishDateLabel: comment.createdAtEnglishDateLabel,
    timeLabel24h: comment.createdAtTimeLabel24h,
  );
}
