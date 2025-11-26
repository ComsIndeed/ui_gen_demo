import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:llm_json_stream/classes/json_stream_parser.dart';
import 'package:llm_json_stream/json_stream_parser.dart';
import 'package:ui_gen_demo/pages/homepage/chat_view/message_box.dart';
import 'package:ui_gen_demo/widgets/accumulating_stream_builder.dart';

/// The service for constructing message widgets from LLM JSON responses
class LLMMessageService extends ChangeNotifier {
  // ignore: non_constant_identifier_names
  static String get WIDGET_GENERATION_PROMPT => '''
Your response must be a valid JSON object. The JSON object will have a "components" key, which will be a list of components. 
Each component will have a "type" key, which will be a string, and the next keys will be the properties of the component.

The available component types are:
- "text": A text component. It will have a "text" key, which will be a string.
- "image": An image component. It will have a "url" key, which will be a string.
- "button": A button component. It will have a "label" key, which will be the text shown in the button component, and an "action" key, which will be a string containing Dart code.
'''; // TODO: PLACEHOLDER PROMPT

  /// Provides the full widget to be displayed
  Widget createMessageWidget({
    String? fullJson,
    Stream<String>? jsonStream,
    required VoidCallback notifyListeners,
  }) {
    if (fullJson == null && jsonStream == null) {
      throw ArgumentError('Either fullJson or jsonStream must be provided');
    }

    final input = jsonStream ?? Stream.value(fullJson!);
    final parser = JsonStreamParser(input);

    final childrenNotifier = ValueNotifier<List<Widget>>([]);

    parser.getListProperty("components").onElement((propertyStream, index) {
      final mapPropertyStream = propertyStream as MapPropertyStream;
      final widget = _createWidgetFromType(
        mapPropertyStream: mapPropertyStream,
      );
      // Create a new list to trigger ValueNotifier update
      childrenNotifier.value = [...childrenNotifier.value, widget];
      notifyListeners();
    });

    return ValueListenableBuilder<List<Widget>>(
      valueListenable: childrenNotifier,
      builder: (context, children, _) {
        return MessageBox(children: children);
      },
    );
  }

  Widget _createWidgetFromType({required MapPropertyStream mapPropertyStream}) {
    final typeFuture = mapPropertyStream.getStringProperty('type').future;

    return FutureBuilder(
      future: typeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        final type = snapshot.data!;
        switch (type) {
          case 'text':
            // Get the text property stream and accumulate chunks
            final textStream = mapPropertyStream
                .getStringProperty('text')
                .stream;
            return RepaintBoundary(
              child: AccumulatingStreamBuilder(
                stream: textStream,
                builder: (context, accumulatedText) {
                  return Text(accumulatedText);
                },
                loadingWidget: const Text(''),
              ),
            );
          case 'image':
            return RepaintBoundary(
              child: AccumulatingStreamBuilder(
                stream: mapPropertyStream.getStringProperty('url').stream,
                builder: (context, accumulatedUrl) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Text("Image: $accumulatedUrl"),
                  );
                },
              ),
            );
          case 'button':
            return RepaintBoundary(
              child: AccumulatingStreamBuilder(
                stream: mapPropertyStream.getStringProperty('label').stream,
                builder: (context, accumulatedText) {
                  return ElevatedButton(
                    onPressed: () {},
                    child: Text(accumulatedText),
                  );
                },
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
