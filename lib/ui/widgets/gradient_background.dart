import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget? child;

  const GradientBackground({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff03001e),
            Color(0xff7303c0),
            Color(0xffec38bc),
            Color(0xfffdeff9),
          ],
          stops: [0, 0.34, 0.67, 1],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/tinder_logo_white1.png',
              width: 250,
            ),
          ),
          if (child != null)
            Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                Expanded(child: child!),
              ],
            )
        ],
      ),
    );
  }
}
