// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import '../../Components/custom_dialog.dart';
import '../../Components/styles.dart';
import '../../Database/database_functions.dart';
import '../../Database/models/user_model.dart';
import '../login_screen.dart';
import 'account_info.dart';
import 'app_info.dart';
import 'privacy_policy.dart';

class MySettingsList extends StatelessWidget {
  UserModal userData;
  MySettingsList({Key? key, required this.userData});

  final List<IconData> icons = [
    Icons.person_2_outlined,
    Icons.lock_outline,
    Icons.info_outline,
    Icons.delete_outline,
    Icons.logout_outlined,
  ];

  final List<String> titles = [
    'Account Info',
    'Privacy & Policy',
    'App Info',
    'Clear App Data',
    'Sign Out',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 5,
      separatorBuilder: (context, index) => Divider(
        indent: 30,
        color: accentColor2,
      ),
      itemBuilder: (context, index) {
        bool hasTrailing =
            index < 3; // Add a condition to show trailing for the first 3 items
        Color trailingColor = index == 4 ? Colors.red : primaryColor;
        return GestureDetector(
          onTap: () {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountInfoScreen(
                            user: userData,
                          )),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppInfo()),
                );
                break;
              case 3:
                customDialog(
                  context: context,
                  text: 'Clear your app data?',
                  subText:
                      "Any drafts that you've saved will be clear on this device",
                  signOrClear: 'Clear',
                  onPressed: () {
                    DatabaseHelper.instance.deleteAllTrips(userData.id!);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('All your data has been cleared'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 1),
                    ));
                  },
                );
                break;
              case 4:
                customDialog(
                  context: context,
                  text: 'Sign out your account?',
                  subText:
                      "Any drafts that you've saved will still be available on this device",
                  signOrClear: 'Sign Out',
                  onPressed: () {
                    DatabaseHelper.instance.signoutUser();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                );
                break;
            }
          },
          child: Container(
            height: 50,
            child: ListTile(
              horizontalTitleGap: 5,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                icons[index],
                color: trailingColor,
              ),
              title: Text(
                titles[index],
                style: TextStyle(color: trailingColor),
              ),
              trailing: hasTrailing
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: trailingColor,
                      ),
                      onPressed: () {},
                    )
                  : null, // Set trailing to null for the last two items
            ),
          ),
        );
      },
    );
  }
}
