import 'package:flutter/widgets.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:llm_json_stream/llm_json_stream.dart';
import 'package:ui_gen_demo/widgets/accumulating_stream_builder.dart';

class StreamingText extends StatelessWidget {
  const StreamingText({super.key, required this.mapPropertyStream});

  final MapPropertyStream mapPropertyStream;

  @override
  Widget build(BuildContext context) {
    final displayTextStream = (mapPropertyStream.getStringProperty(
      'displayText',
    )).stream;

    return AccumulatingStreamBuilder(
      stream: displayTextStream,
      builder: (context, snapshot) => MarkdownBody(data: snapshot),
    );
  }
}
