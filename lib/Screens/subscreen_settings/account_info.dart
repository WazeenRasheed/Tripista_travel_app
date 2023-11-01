// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import '../../Components/styles.dart';
import '../../Database/models/user_model.dart';

class AccountInfoScreen extends StatelessWidget {
  UserModal user;
  AccountInfoScreen({super.key, required this.user});

  final List<IconData> icons = [
    Icons.person_2_outlined,
    Icons.mail_outline,
    Icons.lock_outline,
  ];

  final List<String> titles = [
    'username',
    'email',
    'password',
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> subtitle = [user.name, user.mail, user.password];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        title: Text(
          'Account Info',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional(0.8, 1),
              children: [
                CircleAvatar(
                  maxRadius: 55,
                  backgroundImage: FileImage(File(user.image!)),
                ),
                CircleAvatar(
                    maxRadius: 14,
                    backgroundColor: accentColor2,
                    child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.edit,
                          size: 16,
                          color: primaryColor,
                        )))
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ListView.separated(
                shrinkWrap: true,
                itemCount: 3,
                separatorBuilder: (context, index) => Divider(
                      indent: 46,
                    ),
                itemBuilder: (context, index) {
                  return ListTile(
                    horizontalTitleGap: 5,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      icons[index],
                      color: primaryColor,
                    ),
                    title: Text(
                      titles[index],
                      style: TextStyle(color: primaryColor, fontSize: 13),
                    ),
                    subtitle: Text(
                      subtitle[index],
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: index < 2
                        ? Text(
                            'Edit',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        : Text(
                            'Change',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
