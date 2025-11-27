import 'package:flutter/cupertino.dart';
import 'package:llm_json_stream/llm_json_stream.dart';
import 'package:ui_gen_demo/modules/streaming_widget_module/definitions/widget_namespaces.dart';

typedef StreamingWidgetBuilder =
    Widget Function(BuildContext context, MapPropertyStream mapPropertyStream);

class StreamingWidgetProvider with ChangeNotifier {
  /// The registry of streaming widget builders.
  ///
  /// This is where we define how the widgets get built from their property streams.
  /// To add a new streaming widget, register its builder function here, returning the widget.
  final Map<String, StreamingWidgetBuilder> _streamingWidgetBuilders = {
    WidgetNamespaces.streamingColumn: (context, mapPropertyStream) =>
        SizedBox.shrink(),
    WidgetNamespaces.streamingRow: (context, mapPropertyStream) =>
        SizedBox.shrink(),
    WidgetNamespaces.streamingText: (context, mapPropertyStream) =>
        SizedBox.shrink(),
    WidgetNamespaces.streamingCard: (context, mapPropertyStream) =>
        SizedBox.shrink(),
    WidgetNamespaces.streamingButton: (context, mapPropertyStream) =>
        SizedBox.shrink(),
  };
}
