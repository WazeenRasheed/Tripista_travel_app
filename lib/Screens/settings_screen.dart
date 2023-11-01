// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import '../Components/styles.dart';
import '../Database/models/user_model.dart';
import 'subscreen_settings/settings_list.dart';

class SettingsScreen extends StatelessWidget {
  UserModal user;
  SettingsScreen({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 0, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle( 
                  color: primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: screenSize.height * 0.03,),
            MySettingsList(userData: user,)
          ],
        ),
      )),
    );
  }
}
