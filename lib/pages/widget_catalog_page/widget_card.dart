import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class WidgetCard extends StatelessWidget {
  const WidgetCard({super.key, required this.widget, required this.content});

  final Widget widget;
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 384,
      child: Card(
        child: Row(
          children: [
            widget,
            VerticalDivider(),
            Expanded(child: MarkdownBody(data: content)),
          ],
        ),
      ),
    );
  }
}
