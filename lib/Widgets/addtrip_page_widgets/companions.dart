// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:tripista/Database/database_functions.dart';

import '../../Components/styles.dart';

List<Map<String, dynamic>> companionList = [];
List<Map<String, dynamic>> updatedCompanions = [];

class MyCompanion extends StatelessWidget {
  final String text;
  final BuildContext context;
  final bool functionCheck;
  const MyCompanion(
      {super.key,
      required this.text,
      required this.context,
      this.functionCheck = false});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    void onTapFunction() {
      functionCheck ? selectCompanions() : showCompanions();
    }

    return InkWell(
      onTap: onTapFunction,
      child: Container(
        height: screenSize.height * 0.066,
        width: screenSize.width * 0.43,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: primaryColor),
            borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Icon(
                Icons.group,
                color: accentColor,
              ),
              Text(
                text, // Display selected date or 'Starting date'
                style: TextStyle(fontSize: 12, color: primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> selectCompanions() async {
    try {
      final contact = await FlutterContactPicker.pickPhoneContact();

      if (contact == null) {
        // User canceled contact picking
        print('User canceled picking a contact');
        return;
      }

      String CompanionName = contact.fullName ?? '';
      String CompanionNumber = contact.phoneNumber?.number ?? '';
      if (CompanionName.isNotEmpty && CompanionNumber.isNotEmpty) {
        companionList.add({
          "name": CompanionName,
          "number": CompanionNumber,
        });
        if (CompanionName.isNotEmpty && CompanionNumber.isNotEmpty) {
          updatedCompanions.add({
            "name": CompanionName,
            "number": CompanionNumber,
          });
        }

        print('$CompanionName==$CompanionNumber');
        print('added ${companionList.length}');
      } else {
        print('List is Empty');
      }
    } catch (e) {
      print('Error picking contact: $e');
    }
  }

  Future<dynamic> showCompanions() async {
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: Color.fromARGB(255, 207, 207, 207),
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: StatefulBuilder(
            builder: (context, setState) {
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // Check if the map at the current index is not null before accessing its properties
                  final companion = companionList[index];
                  // check what is constain key
                  if (companion != null &&
                      companion.containsKey("name") &&
                      companion.containsKey("number")) {
                    return Container(
                      height: 70,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(239, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                DatabaseHelper.instance.deleteCompanion(companion['id']);
                                companionList.removeAt(index);
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        title: Text(companion["name"]?.toUpperCase() ?? ""),
                        subtitle: Text(companion["number"] ?? ""),
                      ),
                    );
                  } else {
                    return Container(); // Return an empty container if the companion data is null or incomplete
                  }
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemCount: companionList.length,
              );
            },
          ),
        );
      },
    );
  }
}
