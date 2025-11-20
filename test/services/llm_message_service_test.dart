import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_gen_demo/services/llm_message_service.dart';
import 'package:ui_gen_demo/widgets/accumulating_stream_builder.dart';

void main() {
  testWidgets('LLMMessageService creates streaming button with RepaintBoundary', (
    tester,
  ) async {
    final service = LLMMessageService();
    final controller = StreamController<String>();

    final widget = service.createMessageWidget(
      jsonStream: controller.stream,
      notifyListeners: () {},
    );

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

    // Simulate streaming a button component
    controller.add('{"components": [');
    await tester.pump();
    controller.add('{"type": "button", "label": "Click", "action": "print"}');
    await tester.pump();
    controller.add(']}');
    await tester.pumpAndSettle();

    // Verify Button exists
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Verify Text content (AccumulatingStreamBuilder should have built it)
    // Note: The stream inside AccumulatingStreamBuilder might need time or chunks.
    // But here we sent the full JSON object for the component at once,
    // so the parser should have parsed it.
    // However, the parser streams properties.
    // "label": "Click" -> The parser will stream "Click" to the property stream.

    await tester.pump(); // Allow stream builder to update

    expect(find.text('Click'), findsOneWidget);

    // Verify RepaintBoundary
    // The structure is RepaintBoundary -> AccumulatingStreamBuilder -> ElevatedButton
    final buttonFinder = find.byType(ElevatedButton);
    final accumulatingBuilderFinder = find.ancestor(
      of: buttonFinder,
      matching: find.byType(AccumulatingStreamBuilder),
    );
    expect(accumulatingBuilderFinder, findsOneWidget);

    final repaintBoundaryFinder = find.ancestor(
      of: accumulatingBuilderFinder,
      matching: find.byType(RepaintBoundary),
    );
    expect(repaintBoundaryFinder, findsOneWidget);

    await controller.close();
  });
}
