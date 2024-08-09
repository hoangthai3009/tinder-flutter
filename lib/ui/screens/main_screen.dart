import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tinder/ui/screens/matched_list_screen.dart';
import 'package:tinder/ui/screens/matching_screen.dart';
import 'package:tinder/ui/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = [
    MatchingScreen(),
    MatchingScreen(),
    MatchingScreen(),
    MatchedList(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.fire), label: 'Tinder'),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.magnifyingGlass), label: 'Search'),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.star), label: 'Super Like'),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.comments), label: 'Chat'),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.user), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Theme.of(context).textTheme.displayMedium!.color,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
      ),
    );
  }
}
