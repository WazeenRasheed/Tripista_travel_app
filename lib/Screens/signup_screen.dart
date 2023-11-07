import 'package:flutter/material.dart';
import '../Components/custom_button.dart';
import '../Components/custom_textfield.dart';
import '../Components/logo.dart';
import '../Components/signup_imagepicker.dart';
import '../Components/styles.dart';
import '../Database/database_functions.dart';
import '../Database/models/user_model.dart';
import 'bottom_navigation.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenSize.height * 0.15,
              ),

              //logo
              Container(
                height: screenSize.height * 0.2,
                width: screenSize.width * 0.94,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 24, 0, 0),
                      child: const Logo(imageHeight: 80, fontSize: 25),
                    ),

                    //profile picture
                    MyImagePicker(),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a new account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.035,
                    ),

                    //name textField
                    myTextField(
                      controller: nameController,
                      labelText: 'Enter your username',
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username required';
                        } else if (nameController.text.trim().isEmpty) {
                          return 'Username required ';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.018,
                    ),

                    //mail textField
                    myTextField(
                      controller: mailController,
                      labelText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!isEmailValid(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.018,
                    ),

                    //pwd textField
                    myTextField(
                      controller: passwordController,
                      labelText: 'Enter your password',
                      obscureText: true,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.018,
                    ),

                    //confirm pwd textfield
                    myTextField(
                      controller: confirmPwdController,
                      labelText: 'Confirm password',
                      obscureText: true,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        } else if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.018,
                    ),

                    //signup button
                    MyButton(
                        onTap: () {
                          onSignupButtonClicked();
                        },
                        backgroundColor: primaryColor,
                        text: 'Sign up',
                        textColor: backgroundColor),
                    SizedBox(
                      height: screenSize.height * 0.018,
                    ),

                    //Already have an account ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account ? ',
                          style: TextStyle(fontSize: 15, color: accentColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => LoginScreen()));
                          },
                          child: Text(
                            'Log in',
                            style: TextStyle(
                                fontSize: 15,
                                color: primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenSize.height * 0.05,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSignupButtonClicked() async {
    if (formKey.currentState!.validate()) {
      if (image == null) {
        // Show an error message if the image is not selected.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please add image before submitting the form.'),
            behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.all(20),
          ),
        );
        return;
      }
      final name = nameController.text.trim();
      final mail = mailController.text.trim();
      final password = passwordController.text.trim();

      // Check if the email is already in the database
      final nameExists = await DatabaseHelper.instance.checkIfNameExists(name);

      if (nameExists) {
        // Show an error message if the email already exists in the database.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'This name is already registered. Please use a different name.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final user = UserModal(
          name: name, mail: mail, password: password, image: image!.path);

      final userid = await DatabaseHelper.instance.addUser(user);
      user.id = userid;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => bottomNavigationBar(userdata: user),
        ),
        (route) => false,
      );
    }
  }

  //Email validation
  bool isEmailValid(String email) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}
