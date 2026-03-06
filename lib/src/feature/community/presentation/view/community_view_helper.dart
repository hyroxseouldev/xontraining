import 'package:html/parser.dart' as html_parser;
import 'package:xontraining/l10n/app_localizations.dart';

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
