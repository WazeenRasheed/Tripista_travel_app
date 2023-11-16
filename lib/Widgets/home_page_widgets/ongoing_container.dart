// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import '../../Components/styles.dart';
import '../../Database/models/trip_model.dart';
import '../addtrip_page_widgets/transport_choice.dart';

class OngoingContainer extends StatelessWidget {

  TripModal trip;
  Function()? onTap;
  final coverPic;
  final destination;
  final startingDate;
  final transportIcon;
  OngoingContainer(
      {Key? key,
      required this.trip,
      this.onTap,
      this.coverPic,
      this.destination,
      this.startingDate,
      this.transportIcon});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: screenSize.height * 0.23,
            width: screenSize.width * 0.895,
            decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: coverPic != null
                        ? FileImage(
                            File(coverPic),
                          )
                        : AssetImage('assets/app_logo.png') as ImageProvider)),
          ),
        ),
        SizedBox(
          height: screenSize.height * 0.015,
        ),

        //ongoing transport icon,place,starting date
        Row(
          children: [
            CircleAvatar(
              backgroundColor: accentColor2,
              maxRadius: 13,
              child: Icon(
                iconData[trip.transport],
                size: 16,
                color: primaryColor,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.02,
                ),
                Text(destination != null ? destination : ''),
                SizedBox(
                  width: screenSize.width * 0.04,
                ),
                Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: accentColor2,
                        maxRadius: 13,
                        child: Icon(
                          Icons.calendar_month,
                          size: 15,
                          color: primaryColor,
                        )),
                    SizedBox(
                      width: screenSize.width * 0.02,
                    ),
                    Text(startingDate != null ? startingDate : '')
                  ],
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
