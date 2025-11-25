import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ui_gen_demo/widgets/generative_widgets/generative_button.dart';
import 'package:ui_gen_demo/widgets/generative_widgets/generative_column.dart';
import 'package:ui_gen_demo/widgets/generative_widgets/generative_row.dart';
import 'package:ui_gen_demo/widgets/generative_widgets/generative_text.dart';
import 'package:ui_gen_demo/widgets/generative_widgets/generative_textfield.dart';
import 'package:ui_gen_demo/widgets/generative_widgets/generative_widget_info.dart';

class WidgetCatalogPage extends StatelessWidget {
  const WidgetCatalogPage({super.key});

  static final List<GenerativeWidgetInfo> _widgets = [
    GenerativeFilledButton.info,
    GenerativeElevatedButton.info,
    GenerativeDangerButton.info,
    GenerativeText.info,
    GenerativeTextField.info,
    GenerativeRow.info,
    GenerativeColumn.info,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget Catalog', style: GoogleFonts.roboto()),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: _widgets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final info = _widgets[index];
          return _WidgetCatalogCard(info: info);
        },
      ),
    );
  }
}

class _WidgetCatalogCard extends StatelessWidget {
  final GenerativeWidgetInfo info;

  const _WidgetCatalogCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 400,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left side: Preview
            Expanded(
              flex: 2,
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.title,
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Center(child: info.builder(context)),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () {
                        // Placeholder for run stream
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Run Stream'),
                    ),
                  ],
                ),
              ),
            ),
            // Right side: Info Tabs
            Expanded(
              flex: 3,
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant,
                      tabs: const [
                        Tab(text: 'Purpose'),
                        Tab(text: 'Schema'),
                        Tab(text: 'Example'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Purpose Tab
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Text(
                                info.purpose,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          // Schema Tab
                          ListView.separated(
                            padding: const EdgeInsets.all(24),
                            itemCount: info.schema.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              final entry = info.schema.entries.elementAt(
                                index,
                              );
                              return ListTile(
                                title: Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                subtitle: Text(entry.value),
                              );
                            },
                          ),
                          // Example Tab
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: MarkdownBody(
                              data: '```json\n${info.exampleJson}\n```',
                              selectable: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
