import 'dart:convert';
import 'package:flutter/material.dart';
import 'generative_widget_info.dart';

class GenerativeFilledButton extends StatelessWidget {
  final Stream<String> labelText;
  final Stream<String> iconText;

  GenerativeFilledButton({
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

  static final info = GenerativeWidgetInfo(
    title: 'Filled Button',
    purpose:
        'Filled button component (primary style). Use for primary actions like submitting forms, creating items, or confirming choices.',
    schema: {
      'labelText': 'String - Button label text',
      'iconText': 'String - Icon identifier/name',
      'styleTag': 'String - "primary" for this variant',
    },
    exampleJson:
        '{"labelText": "Submit Form", "iconText": "send", "styleTag": "primary"}',
    builder: (context) => GenerativeFilledButton(
      labelText: Stream.value('Submit Form'),
      iconText: Stream.value('send'),
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

class GenerativeElevatedButton extends StatelessWidget {
  final Stream<String> labelText;
  final Stream<String> iconText;

  GenerativeElevatedButton({
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

  static final info = GenerativeWidgetInfo(
    title: 'Elevated Button',
    purpose:
        'Elevated button component (normal style). Use for secondary actions like viewing, editing, or navigating.',
    schema: {
      'labelText': 'String - Button label text',
      'iconText': 'String - Icon identifier/name',
      'styleTag': 'String - "normal" for this variant',
    },
    exampleJson:
        '{"labelText": "View Details", "iconText": "info", "styleTag": "normal"}',
    builder: (context) => GenerativeElevatedButton(
      labelText: Stream.value('View Details'),
      iconText: Stream.value('info'),
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
              return ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(icon, size: 20),
                label: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
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
              return ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
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

class GenerativeDangerButton extends StatelessWidget {
  final Stream<String> labelText;
  final Stream<String> iconText;

  GenerativeDangerButton({
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

  static final info = GenerativeWidgetInfo(
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
    builder: (context) => GenerativeDangerButton(
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
