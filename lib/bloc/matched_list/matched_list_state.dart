part of 'matched_list_bloc.dart';

abstract class MatchedListState extends Equatable {
  const MatchedListState();

  @override
  List<Object> get props => [];
}

class MatchedListInitial extends MatchedListState {}

class MatchedListLoading extends MatchedListState {}

class MatchedListLoaded extends MatchedListState {
  final List<Match> matchedList;
  final Map<String, Message> lastMessages;

  const MatchedListLoaded(this.matchedList, this.lastMessages);

  @override
  List<Object> get props => [matchedList, lastMessages];
}

class MatchedListError extends MatchedListState {
  final String error;

  const MatchedListError(this.error);

  @override
  List<Object> get props => [error];
}

class MatchedListTokenExpired extends MatchedListState {}
