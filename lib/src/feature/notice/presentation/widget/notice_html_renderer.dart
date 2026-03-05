import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';

class NoticeHtmlRenderer extends StatelessWidget {
  const NoticeHtmlRenderer({required this.html, super.key});

  final String html;

  @override
  Widget build(BuildContext context) {
    final fragment = html_parser.parseFragment(html);
    final blocks = _buildBlocks(context, fragment.nodes);
    if (blocks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks,
    );
  }

  List<Widget> _buildBlocks(BuildContext context, List<dom.Node> nodes) {
    final blocks = <Widget>[];
    for (final node in nodes) {
      final built = _buildNode(context, node);
      if (built != null) {
        blocks.add(built);
      }
    }
    return blocks;
  }

  Widget? _buildNode(BuildContext context, dom.Node node) {
    if (node is dom.Text) {
      final text = node.text.trim();
      if (text.isEmpty) {
        return null;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      );
    }

    if (node is! dom.Element) {
      return null;
    }

    final tag = node.localName?.toLowerCase();
    switch (tag) {
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
        final spans = _inlineSpans(context, node.nodes);
        if (spans.isEmpty) {
          return null;
        }
        final style = switch (tag) {
          'h1' => Theme.of(context).textTheme.headlineMedium,
          'h2' => Theme.of(context).textTheme.headlineSmall,
          'h3' => Theme.of(context).textTheme.titleLarge,
          _ => Theme.of(context).textTheme.titleMedium,
        };
        return Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 10),
          child: RichText(
            text: TextSpan(
              style: style?.copyWith(fontWeight: FontWeight.w800),
              children: spans,
            ),
          ),
        );
      case 'ul':
      case 'ol':
        final items = node.children
            .where((child) => child.localName?.toLowerCase() == 'li')
            .toList(growable: false);
        if (items.isEmpty) {
          return null;
        }
        final isOrdered = tag == 'ol';
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
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
                        child: Text(isOrdered ? '${index + 1}.' : '-'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(height: 1.7),
                            children: _inlineSpans(context, items[index].nodes),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      case 'br':
        return const SizedBox(height: 8);
      default:
        final spans = _inlineSpans(context, node.nodes);
        if (spans.isEmpty) {
          return null;
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RichText(
            text: TextSpan(
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.7),
              children: spans,
            ),
          ),
        );
    }
  }

  List<InlineSpan> _inlineSpans(
    BuildContext context,
    List<dom.Node> nodes, {
    bool bold = false,
    bool italic = false,
    bool underline = false,
    String? href,
  }) {
    final spans = <InlineSpan>[];

    for (final node in nodes) {
      if (node is dom.Text) {
        final value = node.text;
        if (value.trim().isEmpty) {
          continue;
        }
        spans.add(
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              decoration: underline ? TextDecoration.underline : null,
              color: href != null
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            recognizer: href == null
                ? null
                : (TapGestureRecognizer()..onTap = () => _openLink(href)),
          ),
        );
        continue;
      }

      if (node is! dom.Element) {
        continue;
      }

      final tag = node.localName?.toLowerCase();
      spans.addAll(
        _inlineSpans(
          context,
          node.nodes,
          bold: bold || tag == 'strong' || tag == 'b',
          italic: italic || tag == 'em' || tag == 'i',
          underline: underline || tag == 'u',
          href: tag == 'a' ? node.attributes['href'] : href,
        ),
      );
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
