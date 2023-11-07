// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tripista/Components/custom_button.dart';
import 'package:tripista/Components/custom_textfield.dart';
import 'package:tripista/Components/styles.dart';
import 'package:tripista/Database/models/user_model.dart';

class EditPasswordScreen extends StatelessWidget {
  final UserModal user;
  final Function(String) changePassword;
  EditPasswordScreen(
      {super.key, required this.changePassword, required this.user});

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Text(
          "Change password",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter old password'),
                SizedBox(
                  height: 7,
                ),
                myTextField(
                  controller: oldPasswordController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value != user.password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 7,
                ),
                Text('Enter new password'),
                SizedBox(
                  height: 7,
                ),
                myTextField(
                  controller: newPasswordController,
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
                  height: 7,
                ),
                Text('Confirm password'),
                SizedBox(
                  height: 7,
                ),
                myTextField(
                  controller: confirmPasswordController,
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password is required';
                    } else if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.475,
                ),
                MyButton(
                    backgroundColor: primaryColor,
                    text: 'Save',
                    textColor: backgroundColor,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        String newPassword = newPasswordController.text;
                        changePassword(newPassword);
                        Navigator.pop(context);
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Password updated successfully"),
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
