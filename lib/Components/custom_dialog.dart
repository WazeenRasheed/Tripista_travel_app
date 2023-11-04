import 'package:flutter/material.dart';
import 'package:tripista/Components/styles.dart';

customDialog({
  required BuildContext context,
  required String text,
  required String subText,
  required String signOrClear,
  required VoidCallback onPressed,
}) async {
  final Size screenSize = MediaQuery.of(context).size;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: backgroundColor,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400)),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          Text(
            subText,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Text(
            "Cancel",
            style: TextStyle(color: primaryColor, fontSize: 15),
          ),
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Text(signOrClear,
              style: TextStyle(color: Colors.red, fontSize: 15)),
        ),
      ],
    ),
  );
}
