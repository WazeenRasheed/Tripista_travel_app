import 'package:flutter/material.dart';
import 'styles.dart';

class MyButton extends StatelessWidget {
  final Function() onTap;
  final Color backgroundColor;
  final Color textColor;
  final String text;

  MyButton({
    Key? key,
    required this.backgroundColor,
    required this.text,
    required this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    double minWidth = screenSize.width * 0.99;
    double minHeight = 54.0;

    return ElevatedButton(
      onPressed: onTap,
      child: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        minimumSize: Size(minWidth, minHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(width: 1, color: primaryColor),
        ),
      ),
    );
  }
}
