import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ui_gen_demo/services/ai_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiKeyController = TextEditingController();
  final _aiService = AiService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final apiKey = await _aiService.getApiKey();
    if (mounted) {
      setState(() {
        _apiKeyController.text = apiKey ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveApiKey() async {
    await _aiService.saveApiKey(_apiKeyController.text);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('API Key saved')));
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: ResponsiveBreakpoints.of(context).isMobile
                      ? MediaQuery.sizeOf(context).width
                      : MediaQuery.sizeOf(context).width * 0.5,
                  child: ListView(
                    children: [
                      TextField(
                        controller: _apiKeyController,
                        decoration: const InputDecoration(
                          labelText: 'Gemini API Key',
                          border: OutlineInputBorder(),
                          helperText: 'Enter your Gemini API key here',
                        ),
                        obscureText: true,
                        onEditingComplete: _saveApiKey,
                        onSubmitted: (_) => _saveApiKey(),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _saveApiKey,
                        child: const Text('Save API Key'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
