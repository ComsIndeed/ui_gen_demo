import 'package:flutter/cupertino.dart';
import 'package:ui_gen_demo/pages/homepage/chat_view/message_box.dart';
import 'package:ui_gen_demo/services/ai_service.dart';
import 'package:ui_gen_demo/services/llm_message_service.dart';

/// Gives the actual chat message widgets for the chat view
/// - Uses [AiService] to send messages to the AI
/// - Uses [LLMMessageService] to create message widgets from the AI responses
class ChatViewProvider with ChangeNotifier {
  final _aiService = AiService();
  final LLMMessageService _llmMessageService = LLMMessageService();

  final messageWidgets = <Widget>[];

  Future<void> sendMessage(
    String message, {
    String modelName = 'gemini-flash-latest',
  }) async {
    final apiKey = await _aiService.getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API Key not found. Please set it in Settings.');
    }

    messageWidgets.add(MessageBox(isUser: true, children: [Text(message)]));

    final responseStream = _aiService.sendMessage(
      message,
      modelId: modelName,
      apiKey: apiKey,
      systemInstructions: LLMMessageService.WIDGET_GENERATION_PROMPT,
    );

    final messageWidget = _llmMessageService.createMessageWidget(
      jsonStream: responseStream,
      notifyListeners: notifyListeners,
    );

    messageWidgets.add(messageWidget);
    notifyListeners();
  }
}
