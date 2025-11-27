import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ui_gen_demo/widgets/accumulating_stream_builder.dart';

import 'generative_widget_info.dart';

class GenerativeTextField extends StatelessWidget {
  final Stream<String> labelText;
  final Stream<String> hintText;

  GenerativeTextField({
    super.key,
    String? fullJson,
    Stream<String>? labelText,
    Stream<String>? hintText,
  }) : labelText = _resolveStringStream(
         fullJson,
         labelText,
         'labelText',
         'Textfield',
       ),
       hintText = _resolveStringStream(
         fullJson,
         hintText,
         'hintText',
         'Type here',
       ) {
    if (fullJson != null && (labelText != null || hintText != null)) {
      throw ArgumentError(
        'Cannot provide both fullJson and individual streams',
      );
    }
    if (fullJson == null && (labelText == null || hintText == null)) {
      throw ArgumentError(
        'Must provide either fullJson or all stream properties (labelText, hintText)',
      );
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
    title: 'Text Field',
    purpose:
        'Text input field component. Use for collecting user input like names, emails, messages, or search queries.',
    schema: {
      'labelText': 'String - Field label text',
      'hintText': 'String - Placeholder hint text',
    },
    exampleJson:
        '{"labelText": "Email Address", "hintText": "Enter your email"}',
    builder: (context) => GenerativeTextField(
      labelText: Stream.value('Email Address'),
      hintText: Stream.value('Enter your email'),
    ),
  );

  static String get PROMPT => info.prompt;

  @override
  Widget build(BuildContext context) {
    return AccumulatingStreamBuilder(
      stream: labelText,
      builder: (context, accumulatedLabel) {
        return AccumulatingStreamBuilder(
          stream: hintText,
          builder: (context, accumulatedHint) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: accumulatedLabel,
                  hintText: accumulatedHint,
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withOpacity(0.6),
                    fontSize: 16,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
