import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/data/models/chat.dart';
import 'package:tinder/data/models/match.dart';
import 'package:tinder/data/repositories/chat_repository.dart';
import 'package:tinder/data/repositories/match_repository.dart';

part 'matched_list_event.dart';
part 'matched_list_state.dart';

class MatchedListBloc extends Bloc<MatchedListEvent, MatchedListState> {
  MatchedListBloc() : super(MatchedListInitial()) {
    on<LoadMatchedList>((event, emit) async {
      emit(MatchedListLoading());
      try {
        final matchedList = await MatchRepository().getMatches();
        final lastMessages = <String, Message>{};

        for (var match in matchedList) {
          final lastMessage = await ChatRepository().fetchLastMessage(match.id);
          lastMessages[match.id] = lastMessage;
        }

        emit(MatchedListLoaded(matchedList, lastMessages));
      } catch (error) {
        if (error.toString() == 'Exception: TokenExpired') {
          emit(MatchedListTokenExpired());
        } else {
          emit(MatchedListError(error.toString()));
        }
      }
    });
  }
}
