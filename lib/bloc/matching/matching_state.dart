part of 'matching_bloc.dart';

abstract class MatchingState extends Equatable {
  const MatchingState();

  @override
  List<Object> get props => [];
}

class MatchingInitial extends MatchingState {}

class MatchingLoading extends MatchingState {}

class RandomUserLoaded extends MatchingState {
  final User user;

  const RandomUserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ListUsersLoaded extends MatchingState {
  final List<User> users;

  const ListUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class MatchActionSuccess extends MatchingState {}

class MatchingError extends MatchingState {
  final String error;

  const MatchingError(this.error);

  @override
  List<Object> get props => [error];
}

class MatchingTokenExpired extends MatchingState {}
