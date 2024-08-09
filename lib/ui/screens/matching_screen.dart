import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:tinder/bloc/matching/matching_bloc.dart';
import 'package:tinder/data/models/user/user.dart';
import 'package:tinder/shared/component.dart';
import 'package:tinder/ui/widgets/match_card.dart';

class MatchingScreen extends StatelessWidget {
  const MatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: Image.asset(
          'assets/images/tinder_logo2.png',
          fit: BoxFit.cover,
        ),
        leadingWidth: 130,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add action for notifications icon
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.sliders),
            onPressed: () {
              // Add action for settings icon
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => MatchingBloc()..add(LoadListUsersEvent()),
        child: BlocListener<MatchingBloc, MatchingState>(
          listener: (context, state) {
            if (state is MatchingTokenExpired) {
              showSessionExpiredDialog(context);
            }
          },
          child: BlocBuilder<MatchingBloc, MatchingState>(
            builder: (context, state) {
              if (state is MatchingLoading) {
                return buildLoading();
              } else if (state is ListUsersLoaded) {
                final CardSwiperController controller = CardSwiperController();
                List<User> users = state.users;

                if (users.isEmpty) {
                  return const Center(
                    child: Text(
                      'No more users available',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return SafeArea(
                  child: Column(
                    children: [
                      Flexible(
                        child: CardSwiper(
                          controller: controller,
                          cardsCount: users.length,
                          backCardOffset: const Offset(0, 0),
                          numberOfCardsDisplayed: users.length,
                          allowedSwipeDirection: const AllowedSwipeDirection.only(right: true, left: true),
                          onSwipe: (previousIndex, currentIndex, direction) {
                            if (previousIndex < users.length) {
                              final user = users[previousIndex];
                              _onSwipe(context, direction, user, users);
                            }
                            return true;
                          },
                          cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) {
                            final user = users[index];
                            return MatchCard(user: user);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.red,
                              child: IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white, size: 30),
                                onPressed: () => controller.swipe(CardSwiperDirection.left),
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.green,
                              child: IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.white, size: 30),
                                onPressed: () => controller.swipe(CardSwiperDirection.right),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is MatchingError) {
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

  void _onSwipe(BuildContext context, CardSwiperDirection direction, User user, List<User> users) {
    final bloc = BlocProvider.of<MatchingBloc>(context);
    final bool action = direction == CardSwiperDirection.right;
    bloc.add(MatchActionEvent(user2Id: user.id, action: action));
  }
}
