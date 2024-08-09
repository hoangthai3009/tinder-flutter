import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinder/bloc/authentication/authentication_bloc.dart';
import 'package:tinder/bloc/chat/chat_bloc.dart';
import 'package:tinder/bloc/matched_list/matched_list_bloc.dart';
import 'package:tinder/bloc/matching/matching_bloc.dart';
import 'package:tinder/bloc/user/user_bloc.dart';
import 'package:tinder/ui/screens/home_screen.dart';
import 'package:tinder/ui/screens/main_screen.dart';
import 'package:tinder/ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(create: (context) => AuthenticationBloc()..add(AppStarted())),
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<MatchedListBloc>(create: (context) => MatchedListBloc()),
        BlocProvider<MatchingBloc>(create: (context) => MatchingBloc()),
        BlocProvider<ChatBloc>(create: (context) => ChatBloc()),
      ],
      child: MaterialApp(
        title: 'Tinder',
        theme: ThemeData(
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.lightBlueAccent,
            background: Colors.white,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            displayMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
            bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.lightBlueAccent,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/splash': (context) => const SplashScreen(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}
