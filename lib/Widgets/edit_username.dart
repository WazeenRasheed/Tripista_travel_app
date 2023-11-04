// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tripista/Components/custom_button.dart';
import 'package:tripista/Components/custom_textfield.dart';
import 'package:tripista/Components/styles.dart';

class EditUsernameScreen extends StatelessWidget {
  EditUsernameScreen({super.key});

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Text(
          "Change username ",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter new name'),
              SizedBox(height: 7,),
              myTextField(controller: nameController, labelText: ''),
              SizedBox(
                height: screenSize.height * 0.685,
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
