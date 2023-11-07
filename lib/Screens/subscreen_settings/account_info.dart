// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripista/Widgets/edit_email.dart';
import 'package:tripista/Widgets/edit_password.dart';
import 'package:tripista/Widgets/edit_username.dart';
import '../../Components/styles.dart';
import '../../Database/database_functions.dart';
import '../../Database/models/user_model.dart';

class AccountInfoScreen extends StatefulWidget {
  UserModal user;
  AccountInfoScreen({super.key, required this.user});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

File? image;

class _AccountInfoScreenState extends State<AccountInfoScreen> {
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

  updateProfilePicture(File imageFile) async {
    int userId = widget.user.id!;
    String imagePath = imageFile.path;
    await DatabaseHelper.instance.updateUserInfo('image', imagePath, userId);
    setState(() {
      image = imageFile;
    });
  }

  void updateUsername(String newName) async {
    await DatabaseHelper.instance
        .updateUserInfo('name', newName, widget.user.id!);
    setState(() {
      widget.user.name = newName;
    });
  }

  void updateMail(String newMail) async {
    await DatabaseHelper.instance
        .updateUserInfo('mail', newMail, widget.user.id!);
    setState(() {
      widget.user.mail = newMail;
    });
  }

  void updatePassword(String newPassword) async {
    await DatabaseHelper.instance
        .updateUserInfo('password', newPassword, widget.user.id!);
    setState(() {
      widget.user.password = newPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> subtitle = [
      widget.user.name,
      widget.user.mail,
      widget.user.password
    ];

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
            //profile picture
            Stack(
              alignment: AlignmentDirectional(0.8, 1),
              children: [
                CircleAvatar(
                  maxRadius: 55,
                  backgroundImage: image != null
                      ? FileImage(image!)
                      : FileImage(File(widget.user.image!)),
                ),
                CircleAvatar(
                    maxRadius: 14,
                    backgroundColor: accentColor2,
                    child: GestureDetector(
                        onTap: () {
                          addImage();
                        },
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
                      indent: 30,
                      color: accentColor2,
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
                    subtitle: index == 2
                        ? Text(
                            // hide password with * and showing last 3 letter
                            '*' * (subtitle[index].length - 3) +
                                subtitle[index]
                                    .substring(subtitle[index].length - 3),
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          )
                        : Text(
                            subtitle[index],
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                    trailing: index == 0
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditUsernameScreen(
                                    editUsername: updateUsername,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          )
                        : index == 1
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditEmailScreen(editMail: updateMail),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return EditPasswordScreen(
                                          user: widget.user,
                                          changePassword: updatePassword);
                                    },
                                  ));
                                },
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                  );
                })
          ],
        ),
      ),
    );
  }

  addImage() async {
    final imagePicker = ImagePicker();
    showModalBottomSheet(
      elevation: 0,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return BottomSheet(
          elevation: 0,
          onClosing: () {},
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Profile photo',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text("Profile photo updated successfully"),
                                behavior: SnackBarBehavior.floating,
                              ));
                              final pickedImage = await imagePicker.pickImage(
                                source: ImageSource.camera,
                              );
                              if (pickedImage == null) {
                                return;
                              }
                              final imageFile = File(pickedImage.path);
                              updateProfilePicture(imageFile);
                            },
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              maxRadius: 25,
                              child: CircleAvatar(
                                child: Icon(Icons.camera_alt),
                                maxRadius: 24.5,
                                backgroundColor: backgroundColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Camera',
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content:
                                    Text("Profile photo updated successfully"),
                                behavior: SnackBarBehavior.floating,
                              ));
                              final pickedImage = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedImage == null) {
                                return;
                              }
                              final imageFile = File(pickedImage.path);
                              updateProfilePicture(imageFile);
                            },
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              maxRadius: 25,
                              child: CircleAvatar(
                                child: Icon(Icons.photo),
                                maxRadius: 24.5,
                                backgroundColor: backgroundColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Gallery',
                            style: TextStyle(fontSize: 13),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
