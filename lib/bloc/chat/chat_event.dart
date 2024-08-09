part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  final String matchId;

  const LoadMessages({required this.matchId});

  @override
  List<Object> get props => [matchId];
}

class SendMessage extends ChatEvent {
  final String matchId;
  final String text;

  const SendMessage({required this.matchId, required this.text});

  @override
  List<Object> get props => [matchId, text];
}

class NewMessageReceived extends ChatEvent {
  final Message message;

  const NewMessageReceived({required this.message});

  @override
  List<Object> get props => [message];
}
