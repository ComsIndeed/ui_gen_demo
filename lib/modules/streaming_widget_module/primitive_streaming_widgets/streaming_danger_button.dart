import 'dart:convert';
import 'package:flutter/material.dart';
import 'streaming_widget_info.dart';

class StreamingDangerButton extends StatelessWidget {
  final Stream<String> labelText;
  final Stream<String> iconText;

  StreamingDangerButton({
    super.key,
    String? fullJson,
    Stream<String>? labelText,
    Stream<String>? iconText,
  }) : labelText = _resolveStringStream(
         fullJson,
         labelText,
         'labelText',
         'Button',
       ),
       iconText = _resolveStringStream(fullJson, iconText, 'iconText', '') {
    if (fullJson != null && (labelText != null || iconText != null)) {
      throw ArgumentError(
        'Cannot provide both fullJson and individual streams',
      );
    }
    if (fullJson == null && (labelText == null || iconText == null)) {
      throw ArgumentError(
        'Must provide either fullJson or all stream properties (labelText, iconText)',
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

  static final info = StreamingWidgetInfo(
    title: 'Danger Button',
    purpose:
        'Danger button component (destructive action style). Use for destructive actions like deleting, removing, or canceling that cannot be easily undone.',
    schema: {
      'labelText': 'String - Button label text',
      'iconText': 'String - Icon identifier/name',
      'styleTag': 'String - "danger" for this variant',
    },
    exampleJson:
        '{"labelText": "Delete Account", "iconText": "delete", "styleTag": "danger"}',
    builder: (context) => StreamingDangerButton(
      labelText: Stream.value('Delete Account'),
      iconText: Stream.value('delete'),
    ),
  );

  static String get PROMPT => info.prompt;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: labelText,
      initialData: 'Button',
      builder: (context, labelSnapshot) {
        return StreamBuilder<String>(
          stream: iconText,
          initialData: '',
          builder: (context, iconSnapshot) {
            final label = labelSnapshot.data ?? 'Button';
            final iconIdentifier = iconSnapshot.data ?? '';

            // TODO: Implement icon resolution from iconText
            final icon = Icons.circle; // Placeholder

            if (iconIdentifier.isNotEmpty) {
              return FilledButton.icon(
                onPressed: () {},
                icon: Icon(icon, size: 20),
                label: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            } else {
              return FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
