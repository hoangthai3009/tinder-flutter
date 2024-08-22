import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/matched_list/matched_list_bloc.dart';
import 'package:tinder/utils/ui_helpers.dart';
import 'package:tinder/ui/screens/chat_screen.dart';

class MatchedList extends StatelessWidget {
  const MatchedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tin Nhắn"),
      ),
      body: BlocProvider(
        create: (context) => MatchedListBloc()..add(LoadMatchedList()),
        child: BlocListener<MatchedListBloc, MatchedListState>(
          listener: (context, state) {
            if (state is MatchedListTokenExpired) {
              showSessionExpiredDialog(context);
            }
          },
          child: BlocBuilder<MatchedListBloc, MatchedListState>(
            builder: (context, state) {
              if (state is MatchedListLoading) {
                return buildLoading();
              } else if (state is MatchedListLoaded) {
                return ListView.builder(
                  itemCount: state.matchedList.length,
                  itemBuilder: (context, index) {
                    final match = state.matchedList[index];
                    final lastMessage = state.lastMessages[match.id]?.text ?? 'No messages';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                matchId: match.id,
                                userId: match.userId,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(match.userAvatar),
                            radius: 30,
                          ),
                          title: Text(
                            match.userName,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            lastMessage,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is MatchedListError) {
                return buildError(state.error);
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
