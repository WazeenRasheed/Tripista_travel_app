// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../Components/styles.dart';
import '../../Database/database_functions.dart';
import '../../Database/models/trip_model.dart';
import 'imageview_screen.dart';

class MediaTab extends StatefulWidget {
  TripModal trip;
  MediaTab({super.key, required this.trip});

  @override
  State<MediaTab> createState() => _MediaTabState();
}

class _MediaTabState extends State<MediaTab> {
  List<XFile> selectedImages = [];
  List<XFile> newImages = [];
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTripnote().then((storedNote) {
      noteController.text = storedNote ?? '';
    });
    loadImage();
  }

  Future<String?> getTripnote() async {
    final tripId = widget.trip.id;

    if (tripId != null) {
      final temptrip = await DatabaseHelper.instance.getTripById(tripId);
      return temptrip?.notes;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenSize.height * 0.015,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Photos'),
                (InkWell(
                  onTap: () async {
                    final pickedImages = await ImagePicker().pickMultiImage();
                    if (pickedImages.isNotEmpty) {
                      setState(() {
                        newImages.addAll(pickedImages);
                        selectedImages.addAll(newImages);
                      });
                      final tripId = widget.trip.id;
                      await insertSelectedImagesToDatabase(tripId!);
                    }
                  },
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                )),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.015,
            ),
            Wrap(
              spacing: screenSize.width * 0.027,
              runSpacing: screenSize.height * 0.0135,
              children: List.generate(
                selectedImages.length,
                (index) {
                  final imagePath = selectedImages[index].path;

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageViewScreen(
                          imagePaths: selectedImages
                              .map((image) => image.path)
                              .toList(),
                          initialIndex: index,
                          id: widget.trip.id!,
                        ),
                      ));
                    },
                    child: Container(
                      width: screenSize.width * 0.282,
                      height: screenSize.height * 0.125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(imagePath),
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.02,
            ),
            Row(
              children: [
                Text(
                  'Notes',
                  style: TextStyle(color: primaryColor),
                ),
                const Expanded(child: SizedBox()),
                InkWell(
                    onTap: () {
                      DatabaseHelper.instance
                          .addNote(widget.trip, noteController.text);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Saved'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ));
                    },
                    child: Icon(Icons.save_outlined,
                        size: 21, color: primaryColor)),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.015,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.038,
                  vertical: screenSize.height * 0.01),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(width: 1, color: accentColor3)),
              child: TextFormField(
                maxLines: 10,
                maxLength: 500,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Write about your trip',
                    hintStyle: TextStyle(fontSize: 13)),
                controller: noteController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> insertSelectedImagesToDatabase(int tripId) async {
    for (var image in newImages) {
      await DatabaseHelper.instance.addImages(tripId, image.path);
    }
  }

  loadImage() async {
    await DatabaseHelper.instance
        .getAllImages(widget.trip.id!)
        .then((value) => selectedImages = value.map((e) => XFile(e)).toList());
    setState(() {});
  }
}
