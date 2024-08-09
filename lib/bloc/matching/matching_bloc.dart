import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/data/models/user/user.dart';
import 'package:tinder/data/repositories/match_repository.dart';

part 'matching_event.dart';
part 'matching_state.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  MatchingBloc() : super(MatchingInitial()) {
    on<MatchActionEvent>((event, emit) async {
      emit(MatchingLoading());
      try {
        await MatchRepository().matchAction(event.user2Id, event.action);
        emit(MatchActionSuccess());
        add(LoadListUsersEvent());
      } catch (error) {
        if (error.toString() == 'Exception: TokenExpired') {
          emit(MatchingTokenExpired());
        } else {
          emit(MatchingError(error.toString()));
        }
      }
    });

    on<LoadListUsersEvent>((event, emit) async {
      emit(MatchingLoading());
      try {
        final List<User> users = await MatchRepository().getListUsers();
        emit(ListUsersLoaded(users));
      } catch (error) {
        if (error.toString() == 'Exception: TokenExpired') {
          emit(MatchingTokenExpired());
        } else {
          emit(MatchingError(error.toString()));
        }
      }
    });
  }
}
