// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tripista/Components/custom_button.dart';
import 'package:tripista/Components/custom_textfield.dart';
import 'package:tripista/Components/styles.dart';

class EditEmailScreen extends StatelessWidget {
  final Function(String) editMail;
  EditEmailScreen({super.key, required this.editMail});

  TextEditingController mailController = TextEditingController();
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
          "Change email ",
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
                Text('Enter your email'),
                SizedBox(
                  height: 7,
                ),
                myTextField(
                  controller: mailController,
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
                  height: screenSize.height * 0.685,
                ),
                MyButton(
                    backgroundColor: primaryColor,
                    text: 'Save',
                    textColor: backgroundColor,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        String newMail = mailController.text;
                        editMail(newMail);
                        Navigator.pop(context);
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Email updated successfully"),
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

  //Email validation
  bool isEmailValid(String email) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}
