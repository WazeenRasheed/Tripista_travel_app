import 'package:flutter/material.dart';
import 'package:tripista/Components/styles.dart';
import '../Database/models/user_model.dart';
import 'add_trip_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class bottomNavigationBar extends StatefulWidget {
  final UserModal userdata;

  bottomNavigationBar({Key? key, required this.userdata}) : super(key: key);

  @override
  State<bottomNavigationBar> createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  int currentIndexSelect = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndexSelect,
        children: [
          HomeScreen(user: widget.userdata),
          AddTripScreen(user: widget.userdata),
          SearchScreen(user: widget.userdata),
          SettingsScreen(user: widget.userdata),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: accentColor2,
        height: 70,
        elevation: .5,
        backgroundColor: backgroundColor,
        selectedIndex: currentIndexSelect,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndexSelect = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
