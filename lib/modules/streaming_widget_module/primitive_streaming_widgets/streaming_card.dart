import 'package:flutter/material.dart';

class StreamingCard extends StatelessWidget {
  final dynamic itemComponent; // TODO: Change to MapPropertyStream

  StreamingCard({super.key, String? fullJson, this.itemComponent}) {
    if (fullJson != null && itemComponent != null) {
      throw ArgumentError(
        'Cannot provide both fullJson and individual streams',
      );
    }
    if (fullJson == null && itemComponent == null) {
      throw ArgumentError(
        'Must provide either fullJson or itemComponent stream',
      );
    }
  }

  static String get PROMPT => '''
Card container component.
Properties:
- itemComponent: Object - Component object to display inside the card

Example: {"itemComponent": {"type": "StreamingText", "displayText": "Card content"}}
Use for grouping related content, displaying summaries, or creating distinct visual sections.
''';

  @override
  Widget build(BuildContext context) {
    // TODO: Implement itemComponent widget resolution from MapPropertyStream
    final child = const SizedBox(width: 32, height: 32); // Placeholder

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Container(padding: const EdgeInsets.all(20), child: child),
    );
  }
}
