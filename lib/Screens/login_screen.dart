import 'package:flutter/material.dart';

import '../Components/custom_button.dart';
import '../Components/custom_textfield.dart';
import '../Components/logo.dart';
import '../Components/styles.dart';
import '../Database/database_functions.dart';
import 'bottom_navigation.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

//login check
  Future<void> login() async {
    final username = nameController.text;
    final password = passwordController.text;

    // Validate the username and password against the database
    final user = await DatabaseHelper.instance.validateUser(username, password);

    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => bottomNavigationBar(userdata: user),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Invalid Login. Please check your username and password.'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenSize.height * 0.3,
            ),

            //image
            Container(
              height: screenSize.height * 0.22,
              width: screenSize.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Logo(imageHeight: 120, fontSize: 33),
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.05,
            ),

            //Log in to your account
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Log in to your account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.035,
                  ),

                  //text fields
                  myTextField(
                    controller: nameController,
                    hintText: 'Enter your username',
                  ),
                  SizedBox(
                    height: screenSize.height * 0.018,
                  ),
                  myTextField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                    obscureText: true,
                  ),
                  SizedBox(
                    height: screenSize.height * 0.018,
                  ),

                  //login button
                  MyButton(
                      onTap: () {
                        login();
                      },
                      backgroundColor: primaryColor,
                      text: 'Log in',
                      textColor: backgroundColor),
                  SizedBox(
                    height: screenSize.height * 0.018,
                  ),

                  //Don’t have an account ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account ? ',
                        style: TextStyle(fontSize: 15, color: accentColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => SignupScreen()));
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 15,
                              color: primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
