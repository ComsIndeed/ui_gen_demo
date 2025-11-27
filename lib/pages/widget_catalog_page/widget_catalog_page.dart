import 'package:flutter/material.dart';

class WidgetCatalogPage extends StatelessWidget {
  const WidgetCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Catalog')),
      body: const Center(child: Text('Widget Catalog Page Content')),
    );
  }
}
