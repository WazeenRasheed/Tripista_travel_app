import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Components/styles.dart';

File? coverPic;

class addTripCoverPicContainer extends StatefulWidget {
  const addTripCoverPicContainer({super.key});

  @override
  State<addTripCoverPicContainer> createState() =>
      _addTripCoverPicContainerState();
}

class _addTripCoverPicContainerState extends State<addTripCoverPicContainer> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return coverPic == null
        ? Container(
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: primaryColor),
                borderRadius: BorderRadius.circular(6)),
            height: screenSize.height * 0.23,
            width: screenSize.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    addImage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 217, 217, 217),
                    child: Icon(
                      Icons.upload,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                Text('Select cover picture'),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(coverPic!), fit: BoxFit.cover),
                // border: Border.all(width: 1, color: primaryColor),
                borderRadius: BorderRadius.circular(6)),
            height: screenSize.height * 0.23,
            width: screenSize.width * 0.9,
            child: GestureDetector(
              onTap: () {
                addImage();
              },
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
                    'Cover photo',
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
                                coverPic = imageFile;
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
                                coverPic = imageFile;
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
