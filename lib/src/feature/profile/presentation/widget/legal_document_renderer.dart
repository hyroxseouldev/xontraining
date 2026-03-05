import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xontraining/l10n/app_localizations.dart';
import 'package:xontraining/src/feature/profile/infra/entity/legal_document_entity.dart';

class LegalDocumentRenderer extends StatelessWidget {
  const LegalDocumentRenderer({required this.document, super.key});

  final LegalDocumentEntity document;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          '${l10n.legalDocumentVersionLabel} ${document.version}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text(
          '${l10n.legalDocumentUpdatedAtLabel} ${DateFormat.yMMMd(locale.languageCode).format(document.updatedAt)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        ...document.contentJson
            .map((block) => _buildBlock(context, block, l10n))
            .whereType<Widget>(),
      ],
    );
  }

  Widget? _buildBlock(
    BuildContext context,
    Map<String, dynamic> block,
    AppLocalizations l10n,
  ) {
    final type = block['type'] as String?;
    switch (type) {
      case 'group':
        final children = (block['children'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .map((child) => _buildBlock(context, child, l10n))
            .whereType<Widget>()
            .toList(growable: false);
        if (children.isEmpty) {
          return null;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );
      case 'heading':
        final level = (block['level'] as int?) ?? 2;
        final children = _inlineSpans(
          context,
          (block['children'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .toList(growable: false),
        );
        final style = switch (level) {
          1 => Theme.of(context).textTheme.headlineSmall,
          2 => Theme.of(context).textTheme.titleLarge,
          _ => Theme.of(context).textTheme.titleMedium,
        };
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: RichText(
            text: TextSpan(
              style: style?.copyWith(fontWeight: FontWeight.w800),
              children: children,
            ),
          ),
        );
      case 'paragraph':
        final children = _inlineSpans(
          context,
          (block['children'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .toList(growable: false),
        );
        if (children.isEmpty) {
          return null;
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              children: children,
            ),
          ),
        );
      case 'list':
        final ordered = (block['ordered'] as bool?) ?? false;
        final items = (block['items'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>()
            .toList(growable: false);
        if (items.isEmpty) {
          return null;
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < items.length; index += 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(ordered ? '${index + 1}.' : '-'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: _inlineSpans(
                              context,
                              (items[index]['children'] as List<dynamic>? ?? [])
                                  .whereType<Map<String, dynamic>>()
                                  .toList(growable: false),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      default:
        return null;
    }
  }

  List<InlineSpan> _inlineSpans(
    BuildContext context,
    List<Map<String, dynamic>> nodes,
  ) {
    final spans = <InlineSpan>[];

    for (final node in nodes) {
      final type = node['type'] as String?;
      switch (type) {
        case 'text':
          final text = node['text'] as String?;
          if (text != null && text.isNotEmpty) {
            spans.add(TextSpan(text: text));
          }
          break;
        case 'strong':
          final children = _inlineSpans(
            context,
            (node['children'] as List<dynamic>? ?? [])
                .whereType<Map<String, dynamic>>()
                .toList(growable: false),
          );
          if (children.isNotEmpty) {
            spans.add(
              TextSpan(
                style: const TextStyle(fontWeight: FontWeight.w700),
                children: children,
              ),
            );
          }
          break;
        case 'link':
          final text = node['text'] as String?;
          final href = node['href'] as String?;
          if (text == null || text.isEmpty || href == null || href.isEmpty) {
            continue;
          }
          spans.add(
            TextSpan(
              text: text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = () => _openLink(href),
            ),
          );
          break;
        default:
          break;
      }
    }

    return spans;
  }

  Future<void> _openLink(String href) async {
    final uri = Uri.tryParse(href);
    if (uri == null) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
