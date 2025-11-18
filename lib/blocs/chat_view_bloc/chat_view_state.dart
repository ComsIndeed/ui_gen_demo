import 'package:flutter/material.dart';

abstract class ChatViewState {}

class ChatViewInitial extends ChatViewState {}

class MessageReceivedState extends ChatViewState {
  final List<Widget> widgets;
  final bool isGenerating;

  MessageReceivedState({required this.widgets, required this.isGenerating});
}

class MessageErrorState extends ChatViewState {
  final String errorMessage;

  MessageErrorState({required this.errorMessage});
}
