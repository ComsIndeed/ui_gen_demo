abstract class ChatViewEvent {}

class SendMessageEvent extends ChatViewEvent {
  final String message;
  final String modelName;

  SendMessageEvent(this.message, this.modelName);
}
