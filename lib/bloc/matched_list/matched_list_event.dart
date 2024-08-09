part of 'matched_list_bloc.dart';

abstract class MatchedListEvent extends Equatable {
  const MatchedListEvent();

  @override
  List<Object> get props => [];
}

class LoadMatchedList extends MatchedListEvent {}

class LoadLastMessages extends MatchedListEvent {
  final String matchId;

  const LoadLastMessages({required this.matchId});

  @override
  List<Object> get props => [matchId];
}
