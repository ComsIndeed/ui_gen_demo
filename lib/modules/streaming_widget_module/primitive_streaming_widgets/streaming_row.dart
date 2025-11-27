import 'dart:convert';
import 'package:flutter/material.dart';

import 'streaming_widget_info.dart';

class StreamingRow extends StatelessWidget {
  final dynamic itemComponents; // TODO: Change to MapPropertyStream (array)
  final Stream<double> gapNumber;

  StreamingRow({
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

  static final info = StreamingWidgetInfo(
    title: 'Row Layout',
    purpose:
        'Horizontal layout stack component. Use for arranging content horizontally like button groups, tags, or inline elements.',
    schema: {
      'itemComponents':
          'Array<Object> - Array of component objects to display horizontally',
      'gapNumber': 'Number - Spacing between items in pixels',
    },
    exampleJson:
        '{"itemComponents": [{"type": "StreamingFilledButton", "labelText": "Yes"}, {"type": "StreamingElevatedButton", "labelText": "No"}], "gapNumber": 12}',
    builder: (context) => StreamingRow(
      gapNumber: Stream.value(12.0),
      // Placeholder for visual representation in catalog since we can't easily mock children yet
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

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              items[i],
            ],
          ],
        );
      },
    );
  }
}
