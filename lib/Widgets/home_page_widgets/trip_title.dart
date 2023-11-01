import 'package:flutter/material.dart';

class HomeText extends StatelessWidget {
  final String text;
  const HomeText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
    );
  }
}
