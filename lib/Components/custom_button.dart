import 'package:flutter/material.dart';
import 'styles.dart';

class MyButton extends StatelessWidget {
  final Function() onTap;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  const MyButton(
      {super.key,
      required this.backgroundColor,
      required this.text,
      required this.textColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        child: Text(text, style: TextStyle(color: textColor)),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          textStyle: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: textColor),
          minimumSize: Size(353, 54),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(width: 1, color: primaryColor)),
        ));
  }
}
