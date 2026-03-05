import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/notice/infra/entity/notice_entity.dart';
import 'package:xontraining/src/feature/notice/presentation/provider/notice_provider.dart';
import 'package:xontraining/src/shared/empty_state.dart';

class NoticeDetailView extends HookConsumerWidget {
  const NoticeDetailView({
    required this.noticeId,
    this.initialNotice,
    super.key,
  });

  final String noticeId;
  final NoticeEntity? initialNotice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final detailState = ref.watch(noticeDetailProvider(noticeId: noticeId));

    return Scaffold(
      appBar: AppBar(toolbarHeight: 56),
      body: detailState.when(
        loading: () {
          if (initialNotice != null) {
            return _NoticeDetailContent(notice: initialNotice!);
          }
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          if (initialNotice != null) {
            return _NoticeDetailContent(notice: initialNotice!);
          }
          return EmptyState(message: l10n.noticeLoadFailed);
        },
        data: (notice) => _NoticeDetailContent(notice: notice),
      ),
    );
  }
}

class _NoticeDetailContent extends StatelessWidget {
  const _NoticeDetailContent({required this.notice});

  final NoticeEntity notice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateLabel = DateFormat(
      'MMMM, dd, yyyy',
    ).format(notice.createdAt.toLocal());

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (notice.hasThumbnailUrl) ...[
          _NoticeDetailThumbnail(url: notice.normalizedThumbnailUrl),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notice.normalizedTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                dateLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                notice.contentPreview.isEmpty
                    ? l10n.noticeNoContent
                    : notice.contentPreview,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.7),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NoticeDetailThumbnail extends StatelessWidget {
  const _NoticeDetailThumbnail({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, imageUrl) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorWidget: (context, imageUrl, error) {
          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Icon(Icons.broken_image_outlined),
          );
        },
      ),
    );
  }
}
