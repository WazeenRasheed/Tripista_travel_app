import 'package:flutter/material.dart';
import '../Components/custom_button.dart';
import '../Components/logo.dart';
import '../Components/styles.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 30),

            //logo
            Container(
                height: screenSize.height * 0.3,
                width: screenSize.width * 0.7,
                child:
                    Logo(imageHeight: screenSize.height * 0.15, fontSize: 33)),

            Container(
              height: screenSize.height * 0.3,
              width: screenSize.width * 0.9,
              child: Column(
                children: [
                  SizedBox(
                    height: screenSize.height * 0.08,
                  ),

                  //login button
                  MyButton(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => LoginScreen()));
                    },
                    backgroundColor: primaryColor,
                    text: 'Log in',
                    textColor: backgroundColor,
                  ),
                  SizedBox(
                    height: screenSize.height * 0.018,
                  ),

                  //signup button
                  MyButton(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => SignupScreen()));
                    },
                    backgroundColor: backgroundColor,
                    text: 'Sign up',
                    textColor: primaryColor,
                  ),
                  SizedBox(
                    height: screenSize.height * 0.03,
                  ),

                  //version
                  Text(
                    'Version 1.0',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
