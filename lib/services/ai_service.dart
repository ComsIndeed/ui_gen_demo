import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// For managing AI interactions using Google Generative AI and Groq AI APIs.
class AiService {
  static const _storage = FlutterSecureStorage();
  static const _apiKeyKey = 'gemini_api_key';

  Future<String?> getApiKey() async {
    return await _storage.read(key: _apiKeyKey);
  }

  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _apiKeyKey, value: apiKey);
  }

  Stream<String> sendMessage(
    String message, {
    String modelId = 'gemini-flash-latest',
    String? systemInstructions,
    required String apiKey,
  }) {
    if (apiKey.isEmpty) {
      throw Exception('API Key not found. Please set it in Settings.');
    }

    final model = GenerativeModel(
      model: modelId,
      apiKey: apiKey,
      systemInstruction: systemInstructions != null
          ? Content.system(systemInstructions)
          : null,
    );

    final content = [Content.text(message)];
    final response = model.generateContentStream(content);

    return response.map((chunk) => chunk.text!);
  }

  Future<List<String>> listModels() async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API Key not found. Please set it in Settings.');
    }

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> models = data['models'];
      return models
          .map((model) => model['name'].toString().replaceFirst('models/', ''))
          .toList();
    } else {
      throw Exception(
        'Failed to list models: ${response.statusCode} ${response.body}',
      );
    }
  }
}
