import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tinder/data/models/chat.dart';
import 'package:tinder/data/repositories/chat_repository.dart';
import 'package:tinder/shared/constants.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late io.Socket socket;

  ChatBloc() : super(ChatInitial()) {
    _initSocket();

    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        final messages = await ChatRepository().fetchMessages(event.matchId);
        emit(ChatLoaded(messages));
        socket.emit('joinRoom', {'matchId': event.matchId});
      } catch (error) {
        if (error.toString() == 'Exception: TokenExpired') {
          emit(ChatTokenExpired());
        } else {
          emit(ChatError(error.toString()));
        }
      }
    });

    on<SendMessage>((event, emit) async {
      try {
        await ChatRepository().sendMessage(event.matchId, event.text);
      } catch (error) {
        if (error.toString() == 'Exception: TokenExpired') {
          emit(ChatTokenExpired());
        } else {
          emit(ChatError(error.toString()));
        }
      }
    });

    on<NewMessageReceived>((event, emit) {
      if (state is ChatLoaded) {
        final updatedMessages = List<Message>.from((state as ChatLoaded).messages)..add(event.message);
        emit(ChatLoaded(updatedMessages));
      }
    });
  }

  void _initSocket() {
    socket = io.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from server');
    });

    socket.on('message', (data) {
      if (data != null && data['message'] != null) {
        final message = Message.fromJson(data['message']);
        add(NewMessageReceived(message: message));
      }
    });
  }

  @override
  Future<void> close() {
    socket.disconnect();
    socket.dispose();
    return super.close();
  }
}
