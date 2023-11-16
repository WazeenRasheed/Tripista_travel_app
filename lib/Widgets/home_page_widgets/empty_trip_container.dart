// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import '../../Components/styles.dart';
import '../../Database/models/user_model.dart';
import '../../Screens/add_trip_screen.dart';

class EmptyTripContainer extends StatelessWidget {
  UserModal user;
  final IconData? addIcon;
  final String? text1;
  final String? text2;
  final TextStyle? textStyle;
  EmptyTripContainer(
      {super.key,
      this.addIcon,
      this.text1,
      this.text2,
      this.textStyle,
      required this.user});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.2,
      width: screenSize.width * 0.9,
      decoration: BoxDecoration(
        color: accentColor2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTripScreen(user: user),
                    ));
              },
              child: Icon(addIcon)),
          Text(text1 ?? '', style: textStyle ?? TextStyle(fontSize: 10)),
          Text(
            text2 ?? '',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
