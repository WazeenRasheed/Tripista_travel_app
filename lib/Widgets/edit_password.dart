// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tripista/Components/custom_button.dart';
import 'package:tripista/Components/custom_textfield.dart';
import 'package:tripista/Components/styles.dart';

class EditPasswordScreen extends StatelessWidget {
  EditPasswordScreen({super.key});

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter old password'),
              SizedBox(
                height: 7,
              ),
              myTextField(controller: oldPasswordController, labelText: ''),
              SizedBox(
                height: 7,
              ),
              Text('Enter new password'),
              SizedBox(
                height: 7,
              ),
              myTextField(controller: newPasswordController, labelText: ''),
              SizedBox(
                height: 7,
              ),
              Text('Confirm password'),
              SizedBox(
                height: 7,
              ),
              myTextField(controller: confirmPasswordController, labelText: ''),
              SizedBox(
                height: screenSize.height * 0.475,
              ),
              MyButton(
                backgroundColor: primaryColor,
                text: 'Save',
                textColor: backgroundColor,
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
