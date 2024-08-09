import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/chat/chat_bloc.dart';
import 'package:tinder/bloc/user/user_bloc.dart';
import 'package:tinder/shared/component.dart';

class ChatScreen extends StatefulWidget {
  final String matchId;
  final String userId;

  const ChatScreen({super.key, required this.matchId, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = View.of(context).viewInsets.bottom;
    if (bottomInset > 0.0) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserBloc()..add(LoadUserByIdEvent(userId: widget.userId)),
        ),
        BlocProvider(
          create: (_) => ChatBloc()..add(LoadMessages(matchId: widget.matchId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserTokenExpired) {
                  showSessionExpiredDialog(context);
                }
              },
            ),
            BlocListener<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatTokenExpired) {
                  showSessionExpiredDialog(context);
                }
              },
            ),
          ],
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState is UserLoading) {
                return buildLoading();
              } else if (userState is UserLoaded) {
                final tinderMatchId = userState.user.id;
                return BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, chatState) {
                    if (chatState is ChatLoading || chatState is ChatInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (chatState is ChatLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                      return Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: chatState.messages.length,
                              itemBuilder: (context, index) {
                                final message = chatState.messages[index];
                                final isMatchSender = message.sender == tinderMatchId;

                                return ListTile(
                                  leading: isMatchSender ? CircleAvatar(backgroundImage: NetworkImage(userState.user.profile.avatar)) : null,
                                  title: Align(
                                    alignment: isMatchSender ? Alignment.centerLeft : Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 14.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isMatchSender ? Colors.grey[200] : Colors.blue[100],
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Text(message.text),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom + 10.0, // Add padding here
                              left: 8.0,
                              right: 8.0,
                              top: 8.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your message',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.send),
                                  onPressed: () {
                                    final messageText = _controller.text;
                                    if (messageText.isNotEmpty) {
                                      BlocProvider.of<ChatBloc>(context).add(
                                        SendMessage(matchId: widget.matchId, text: messageText),
                                      );
                                      _controller.clear();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (chatState is ChatError) {
                      return buildError(chatState.error);
                    } else {
                      return buildDefaultError();
                    }
                  },
                );
              } else if (userState is UserError) {
                return buildError(userState.error);
              } else {
                return buildDefaultError();
              }
            },
          ),
        ),
      ),
    );
  }
}
