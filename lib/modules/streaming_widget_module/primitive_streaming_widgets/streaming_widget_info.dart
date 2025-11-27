import 'package:flutter/widgets.dart';

class StreamingWidgetInfo {
  final String title;
  final String purpose;
  final Map<String, String> schema;
  final String exampleJson;
  final WidgetBuilder builder;

  const StreamingWidgetInfo({
    required this.title,
    required this.purpose,
    required this.schema,
    required this.exampleJson,
    required this.builder,
  });

  String get prompt {
    final schemaString = schema.entries
        .map((e) => '- ${e.key}: ${e.value}')
        .join('\n');
    return '''
$purpose
Properties:
$schemaString

Example: $exampleJson
''';
  }
}
