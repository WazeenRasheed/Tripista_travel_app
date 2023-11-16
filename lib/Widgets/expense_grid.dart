import 'package:flutter/material.dart';
import '../Components/styles.dart';

Container customGrid(
    {required BuildContext context,
    required String text,
    required int amount,
    required IconData icon,
    required Color bgcolor,
    required Color iconColor}) {
  final Size screenSize = MediaQuery.of(context).size;
  return Container(
    // height: screenSize.height * 0.1,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: accentColor),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenSize.width * 0.029),
          child: Row(
            children: [
              Text(text, style: TextStyle(fontSize: 16, color: primaryColor)),
              Expanded(child: Container()),
              CircleAvatar(
                  backgroundColor: bgcolor,
                  radius: 17,
                  child: Icon(
                    icon,
                    size: 18,
                    color: iconColor,
                  )),
              SizedBox(width: screenSize.width * 0.035)
            ],
          ),
        ),
        Divider(
            height: screenSize.height * 0.02,
            indent: 13,
            endIndent: 13,
            color: accentColor2),
        Padding(
            padding: EdgeInsets.only(
                top: screenSize.height * 0.005, left: screenSize.width * 0.035),
            child: Text("₹ $amount",
                style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w900))),
        SizedBox(
          height: screenSize.height * 0.001,
        ),
      ],
    ),
  );
}
