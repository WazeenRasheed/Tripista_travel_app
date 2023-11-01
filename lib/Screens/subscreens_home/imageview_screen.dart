import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../Components/styles.dart';
import '../../Database/database_functions.dart';

class ImageViewScreen extends StatelessWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final int id;

  ImageViewScreen(
      {required this.imagePaths, required this.initialIndex, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 1,
        title: Text(
          'Photo',
          style: TextStyle(color: primaryColor),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              deleteImage(context);
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 22,
            ),
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: imagePaths.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(imagePaths[index])),
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: backgroundColor,
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }

  deleteImage(BuildContext context) async {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext cont) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () async {
                  DatabaseHelper.instance
                      .deleteImage(id, imagePaths[initialIndex]);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          );
        });
  }
}
