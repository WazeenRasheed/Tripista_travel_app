// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import '../../Components/styles.dart';
import '../../Database/models/trip_model.dart';
import '../addtrip_page_widgets/transport_choice.dart';

class UpcomingRecentContainer extends StatelessWidget {
  final TripModal tripData;
  Function()? onTap;
  final coverPic;
  final destination;
  final startingDate;

  UpcomingRecentContainer({
    super.key,
    this.onTap,
    this.coverPic,
    this.destination,
    this.startingDate,
    required this.tripData,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              screenSize.width * 0.005,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: coverPic != null
                  ? FileImage(
                      File(coverPic),
                    )
                  : AssetImage('assets/app_logo.png') as ImageProvider,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              screenSize.width * 0.035, 
              screenSize.height * 0.015, 
              screenSize.width * 0.03, 
              screenSize.height * 0.0, 
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      child: Icon(
                        iconData[tripData.transport],
                        size: 14,
                        color: primaryColor,
                      ),
                      maxRadius: 11,
                      backgroundColor: backgroundColor,
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.108,
                ),
                Text(
                  destination != null ? destination : 'no data',
                  style: TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  startingDate != null ? startingDate : 'data',
                  style: TextStyle(
                    color: backgroundColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
