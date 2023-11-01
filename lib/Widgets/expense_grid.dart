import 'package:flutter/material.dart';
import '../Components/styles.dart';

Container customGrid(
    {required String text,
    required int amount,
    required IconData icon,
    required Color bgcolor,
    required Color iconColor}) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: accentColor),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
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
              const SizedBox(width: 15)
            ],
          ),
        ),
        const Divider(thickness: .5, height: 18,indent: 10,endIndent: 10,),
        Padding(
            padding: const EdgeInsets.only(top: 3, left: 12),
            child: Text("₹ $amount",
                style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w900))),
        const SizedBox(
          height: 5,
        ),
      ],
    ),
  );
}
