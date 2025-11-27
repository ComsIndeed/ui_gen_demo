import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:ui_gen_demo/widgets/accumulating_stream_builder.dart';

import 'generative_widget_info.dart';

class GenerativeText extends StatelessWidget {
  final Stream<String> displayText;

  GenerativeText({super.key, String? fullJson, Stream<String>? displayText})
    : displayText = _resolveStringStream(
        fullJson,
        displayText,
        'displayText',
        'Text',
      ) {
    if (fullJson != null && displayText != null) {
      throw ArgumentError(
        'Cannot provide both fullJson and individual streams',
      );
    }
    if (fullJson == null && displayText == null) {
      throw ArgumentError('Must provide either fullJson or displayText stream');
    }
  }

  static Stream<String> _resolveStringStream(
    String? fullJson,
    Stream<String>? stream,
    String key,
    String defaultValue,
  ) {
    if (fullJson != null) {
      try {
        final Map<String, dynamic> parsed = jsonDecode(fullJson);
        final val = parsed[key];
        if (val is String) return Stream.value(val);
        return Stream.value(defaultValue);
      } catch (e) {
        return Stream.value(defaultValue);
      }
    }
    return stream ?? Stream.value(defaultValue);
  }

  static final info = GenerativeWidgetInfo(
    title: 'Markdown Text',
    purpose:
        'Markdown text display component. Supports markdown features like headings, bold, italic, lists, code blocks, and links.',
    schema: {
      'displayText': 'String - Text content with markdown formatting support',
    },
    exampleJson:
        '{"displayText": "# Welcome\\n\\nThis is **bold** and *italic* text.\\n\\n- Item 1\\n- Item 2"}',
    builder: (context) => GenerativeText(
      displayText: Stream.value(
        '# Welcome\n\nThis is **bold** and *italic* text.',
      ),
    ),
  );

  static String get PROMPT => info.prompt;

  @override
  Widget build(BuildContext context) {
    return AccumulatingStreamBuilder(
      stream: displayText,
      builder: (context, accumulated) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: MarkdownBody(
            data: accumulated,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              h1: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.3,
              ),
              h2: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.3,
              ),
              h3: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.3,
              ),
              code: TextStyle(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'monospace',
                fontSize: 14,
              ),
              codeblockDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              blockquote: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
              blockquoteDecoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
                ),
              ),
              listBullet: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
