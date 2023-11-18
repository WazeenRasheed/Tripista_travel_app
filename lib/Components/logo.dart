import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double imageHeight;
  final double fontSize;
  const Logo({super.key, required this.imageHeight, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/app_logo.png',
          height: imageHeight,
        ),
        const SizedBox(
          height: 10,
        ),
        // Text(
        //   'Tripista',
        //   style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w900),
        // ),
      ],
    );
  }
}
