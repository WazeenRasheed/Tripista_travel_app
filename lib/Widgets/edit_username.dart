// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:tripista/Components/custom_button.dart';
import 'package:tripista/Components/custom_textfield.dart';
import 'package:tripista/Components/styles.dart';

class EditUsernameScreen extends StatelessWidget {
  final Function(String) editUsername;
  EditUsernameScreen({super.key, required this.editUsername});

  TextEditingController nameController = TextEditingController();
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
          "Change username ",
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
                Text('Enter your name'),
                SizedBox(
                  height: 7,
                ),
                myTextField(
                  controller: nameController,
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
                  height: screenSize.height * 0.685,
                ),
                MyButton(
                    backgroundColor: primaryColor,
                    text: 'Save',
                    textColor: backgroundColor,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        String newName = nameController.text;
                        editUsername(newName);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Username updated successfully"),
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
