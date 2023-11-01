import 'package:flutter/material.dart';
import '../Components/styles.dart';
import '../Database/models/user_model.dart';
import 'add_trip_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class bottomNavigationBar extends StatefulWidget {
  final UserModal userdata;
  bottomNavigationBar({super.key,required this.userdata});
  

  @override
  State<bottomNavigationBar> createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  int currentIndexSelect = 0;
  List<Widget>? pages;
  ValueNotifier<int> pageNotifier =ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    pages = [
      HomeScreen(user: widget.userdata),
      AddTripScreen(user: widget.userdata,),
      SearchScreen(user: widget.userdata),
      SettingsScreen(user: widget.userdata,)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ValueListenableBuilder<int>(
          valueListenable: pageNotifier,
          builder: (context ,value,_) {
            return pages![value];
          }
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: pageNotifier,
          builder: (context,val,_) {
            return BottomNavigationBar(
              backgroundColor: backgroundColor,
              iconSize: 25,
              elevation: 7,
              selectedItemColor: primaryColor,
              type: BottomNavigationBarType.fixed,
              currentIndex: pageNotifier.value,
              onTap: (newindex) {
              pageNotifier.value=newindex;
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle_outline), label: 'Add'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings_outlined), label: 'Settings'),
              ],
            );
          }
        ));
  }
}
