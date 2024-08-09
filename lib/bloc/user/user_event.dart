part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUserEvent extends UserEvent {}

class LoadUserByIdEvent extends UserEvent {
  final String userId;

  const LoadUserByIdEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUserEvent extends UserEvent {
  final User user;

  const UpdateUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}
