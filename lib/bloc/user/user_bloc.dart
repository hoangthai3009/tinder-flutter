import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/data/models/user/user.dart';
import 'package:tinder/data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await UserRepository().getUserProfile();
        emit(UserLoaded(user: user));
      } catch (error) {
        if (error.toString() == 'Exception: TokenExpired') {
          emit(UserTokenExpired());
        } else {
          emit(UserError(error: error.toString()));
        }
      }
    });

    on<LoadUserByIdEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await UserRepository().getUserProfileByUserId(event.userId);
        emit(UserLoaded(user: user));
      } catch (error) {
        if (error.toString() == 'Exception: TokenExpired') {
          emit(UserTokenExpired());
        } else {
          emit(UserError(error: error.toString()));
        }
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        await UserRepository().updateUserProfile(event.user);
        final updatedUser = await UserRepository().getUserProfile();
        emit(UserLoaded(user: updatedUser));
      } catch (error) {
        if (error.toString() == 'Exception: TokenExpired') {
          emit(UserTokenExpired());
        } else {
          emit(UserError(error: error.toString()));
        }
      }
    });
  }
}
