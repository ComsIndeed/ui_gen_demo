import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: ResponsiveBreakpoints.of(context).isMobile
                ? MediaQuery.sizeOf(context).width
                : MediaQuery.sizeOf(context).width * 0.5,
            child: ListView(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                  child: const Text('Back'),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'API Key',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
