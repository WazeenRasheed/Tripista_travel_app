import 'package:flutter/material.dart';

import '../Components/logo.dart';
import '../Components/styles.dart';
import '../Database/database_functions.dart';
import '../Database/models/user_model.dart';
import 'bottom_navigation.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    goToLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(imageHeight: screenSize.height * 0.15, fontSize: 33),
            ],
          ),
        ],
      ),
    );
  }

  goToLogin() async {
    await Future.delayed(Duration(seconds: 1));

    UserModal? userData = await DatabaseHelper.instance.getUserLogged();

    if (userData != null) {
      // User is logged in, navigate to bottomNavigationBar
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => bottomNavigationBar(userdata: userData),
        ),
        (route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false,
      );
    }
  }
}
