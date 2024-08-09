import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinder/bloc/authentication/authentication_bloc.dart';
import 'package:tinder/ui/screens/home_screen.dart';
import 'package:tinder/ui/screens/main_screen.dart';
import 'package:tinder/ui/widgets/gradient_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccess) {
            _navigateTo(context, const MainScreen());
          } else if (state is AuthenticationInitial || state is AuthenticationFailure) {
            _navigateTo(context, const HomeScreen());
          }
        },
        child: const GradientBackground(),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    });
  }
}
