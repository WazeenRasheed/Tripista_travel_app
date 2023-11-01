import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

customDialog({
  required BuildContext context,
  required String text,
  required String subText,
  required String signOrClear,
  required VoidCallback onPressed,
}) async {
  showDialog(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Column(
        children: [
          Text(text),
          Text(
            subText,
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      actions: [
        CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        CupertinoButton(
          onPressed: onPressed,
          child: Text(signOrClear, style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
