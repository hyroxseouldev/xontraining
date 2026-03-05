import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

class LegalHtmlParser {
  List<Map<String, dynamic>> parseToJson(String html) {
    final fragment = html_parser.parseFragment(html);
    final blocks = <Map<String, dynamic>>[];

    for (final node in fragment.nodes) {
      final block = _parseNode(node);
      if (block != null) {
        blocks.add(block);
      }
    }

    return blocks;
  }

  Map<String, dynamic>? _parseNode(dom.Node node) {
    if (node is dom.Text) {
      final text = _normalize(node.text);
      if (text.isEmpty) {
        return null;
      }
      return {
        'type': 'paragraph',
        'children': [_textSpan(text)],
      };
    }

    if (node is! dom.Element) {
      return null;
    }

    switch (node.localName) {
      case 'h1':
        return _heading(node, 1);
      case 'h2':
        return _heading(node, 2);
      case 'h3':
        return _heading(node, 3);
      case 'p':
        return _paragraph(node);
      case 'ul':
        return _list(node, ordered: false);
      case 'ol':
        return _list(node, ordered: true);
      case 'div':
      case 'section':
      case 'article':
        final children = <Map<String, dynamic>>[];
        for (final child in node.nodes) {
          final parsed = _parseNode(child);
          if (parsed != null) {
            children.add(parsed);
          }
        }
        if (children.isEmpty) {
          return null;
        }
        return {'type': 'group', 'children': children};
      default:
        final paragraph = _paragraph(node);
        return paragraph['children'] is List &&
                (paragraph['children'] as List).isNotEmpty
            ? paragraph
            : null;
    }
  }

  Map<String, dynamic> _heading(dom.Element element, int level) {
    return {
      'type': 'heading',
      'level': level,
      'children': _parseInlineNodes(element.nodes),
    };
  }

  Map<String, dynamic> _paragraph(dom.Element element) {
    return {'type': 'paragraph', 'children': _parseInlineNodes(element.nodes)};
  }

  Map<String, dynamic> _list(dom.Element element, {required bool ordered}) {
    final items = <Map<String, dynamic>>[];
    for (final item in element.children.where((e) => e.localName == 'li')) {
      final children = _parseInlineNodes(item.nodes);
      if (children.isEmpty) {
        continue;
      }
      items.add({'children': children});
    }

    return {'type': 'list', 'ordered': ordered, 'items': items};
  }

  List<Map<String, dynamic>> _parseInlineNodes(List<dom.Node> nodes) {
    final spans = <Map<String, dynamic>>[];

    for (final node in nodes) {
      if (node is dom.Text) {
        final text = _normalize(node.text);
        if (text.isEmpty) {
          continue;
        }
        spans.add(_textSpan(text));
        continue;
      }

      if (node is! dom.Element) {
        continue;
      }

      switch (node.localName) {
        case 'strong':
        case 'b':
          final children = _parseInlineNodes(node.nodes);
          if (children.isNotEmpty) {
            spans.add({'type': 'strong', 'children': children});
          }
          break;
        case 'a':
          final text = _normalize(node.text);
          if (text.isNotEmpty) {
            spans.add({
              'type': 'link',
              'text': text,
              'href': node.attributes['href'] ?? '',
            });
          }
          break;
        case 'br':
          spans.add(_textSpan('\n'));
          break;
        default:
          final nested = _parseInlineNodes(node.nodes);
          spans.addAll(nested);
          break;
      }
    }

    return spans;
  }

  Map<String, dynamic> _textSpan(String text) {
    return {'type': 'text', 'text': text};
  }

  String _normalize(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
