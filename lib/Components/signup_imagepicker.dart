import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'styles.dart';

File? image;

class MyImagePicker extends StatefulWidget {
  const MyImagePicker({super.key});

  @override
  State<MyImagePicker> createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  @override
  Widget build(BuildContext context) {
    return image == null
        ? CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black12,
            child: IconButton(
              onPressed: () {
                addImage();
              },
              icon: Icon(
                Icons.person_add_alt_1,
                color: Colors.black,
              ),
              iconSize: 40,
            ),
          )
        : InkWell(
            onTap: () {
              addImage();
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(image!),
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
                              final pickedImage = await imagePicker.pickImage(
                                source: ImageSource.camera,
                              );
                              if (pickedImage == null) {
                                return;
                              }
                              final imageFile = File(pickedImage.path);
                              setState(() {
                                image = imageFile;
                              });
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
                              final pickedImage = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedImage == null) {
                                return;
                              }
                              final imageFile = File(pickedImage.path);
                              setState(() {
                                image = imageFile;
                              });
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
