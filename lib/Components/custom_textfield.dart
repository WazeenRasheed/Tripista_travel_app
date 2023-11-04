// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'styles.dart';

class myTextField extends StatelessWidget {
  final controller;
  String? labelText;
  String? hintText;
  final TextInputType? keyboardType;
  FormFieldValidator? validation;
  final bool? obscureText;

  myTextField(
      {super.key,
      required this.controller,
      this.labelText,
      this.hintText,
      this.keyboardType,
      this.obscureText = false,
      this.validation});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      validator: validation,
      decoration: InputDecoration(
        contentPadding: //textfield height
            EdgeInsets.symmetric(vertical: 17, horizontal: 20),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 15, color: accentColor),
        hintStyle: TextStyle(color: accentColor, fontSize: 15),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: primaryColor,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: primaryColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.red)),
      ),
    );
  }
}
