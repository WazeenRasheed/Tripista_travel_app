import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () async {
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
                child: Text('Take Photo'),
              ),
              CupertinoActionSheetAction(
                onPressed: () async {
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
                child: Text('Choose Photo'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          );
        });
  }
}
