import 'dart:convert';
import 'package:flutter/material.dart';

import 'generative_widget_info.dart';

class GenerativeColumn extends StatelessWidget {
  final dynamic itemComponents; // TODO: Change to MapPropertyStream (array)
  final Stream<double> gapNumber;

  GenerativeColumn({
    super.key,
    String? fullJson,
    this.itemComponents,
    Stream<double>? gapNumber,
  }) : gapNumber = _resolveDoubleStream(fullJson, gapNumber, 'gapNumber', 8.0) {
    if (fullJson != null && (itemComponents != null || gapNumber != null)) {
      throw ArgumentError(
        'Cannot provide both fullJson and individual streams',
      );
    }
    if (fullJson == null && (itemComponents == null || gapNumber == null)) {
      throw ArgumentError(
        'Must provide either fullJson or all stream properties (itemComponents, gapNumber)',
      );
    }
  }

  static Stream<double> _resolveDoubleStream(
    String? fullJson,
    Stream<double>? stream,
    String key,
    double defaultValue,
  ) {
    if (fullJson != null) {
      try {
        final Map<String, dynamic> parsed = jsonDecode(fullJson);
        final val = parsed[key];
        if (val is num) return Stream.value(val.toDouble());
        return Stream.value(defaultValue);
      } catch (e) {
        return Stream.value(defaultValue);
      }
    }
    return stream ?? Stream.value(defaultValue);
  }

  static final info = GenerativeWidgetInfo(
    title: 'Column Layout',
    purpose:
        'Vertical layout stack component. Use for stacking content vertically like lists, forms, or sequential information.',
    schema: {
      'itemComponents':
          'Array<Object> - Array of component objects to display vertically',
      'gapNumber': 'Number - Spacing between items in pixels',
    },
    exampleJson:
        '{"itemComponents": [{"type": "GenerativeText", "displayText": "Item 1"}, {"type": "GenerativeText", "displayText": "Item 2"}], "gapNumber": 16}',
    builder: (context) => GenerativeColumn(
      gapNumber: Stream.value(16.0),
      // Placeholder for visual representation
    ),
  );

  static String get PROMPT => info.prompt;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: gapNumber,
      initialData: 8.0,
      builder: (context, gapSnapshot) {
        final gap = gapSnapshot.data ?? 8.0;

        // TODO: Implement itemComponents widget resolution from MapPropertyStream array
        final items = <Widget>[]; // Placeholder

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) SizedBox(height: gap),
              items[i],
            ],
          ],
        );
      },
    );
  }
}
