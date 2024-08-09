part of 'matching_bloc.dart';

abstract class MatchingEvent extends Equatable {
  const MatchingEvent();

  @override
  List<Object> get props => [];
}

class LoadListUsersEvent extends MatchingEvent {}

class MatchActionEvent extends MatchingEvent {
  final String user2Id;
  final bool action;

  const MatchActionEvent({required this.user2Id, required this.action});

  @override
  List<Object> get props => [user2Id, action];
}
