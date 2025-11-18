import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_gen_demo/blocs/chat_view_bloc/chat_view_event.dart';
import 'package:ui_gen_demo/blocs/chat_view_bloc/chat_view_state.dart';

class ChatViewBloc extends Bloc<ChatViewEvent, ChatViewState> {
  ChatViewBloc() : super(ChatViewInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  FutureOr<void> _onSendMessage(event, emit) async {}
}
