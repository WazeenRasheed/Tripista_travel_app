// ignore_for_file: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Components/styles.dart';
import '../../Database/database_functions.dart';
import '../../Database/models/trip_model.dart';
import '../../Database/models/user_model.dart';
import '../../Widgets/home_page_widgets/ongoing_container.dart';
import '../add_trip_screen.dart';
import '../bottom_navigation.dart';

class UpcomingTripScreen extends StatefulWidget {
  UserModal user;
  TripModal trip;
  UpcomingTripScreen({super.key, required this.user, required this.trip});

  @override
  State<UpcomingTripScreen> createState() => _UpcomingTripScreenState();
}

class _UpcomingTripScreenState extends State<UpcomingTripScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
          widget.trip.tripName,
          style: TextStyle(color: primaryColor),
        ),
        actions: [
          Builder(
            builder: (context) => PopupMenuButton(
              color: backgroundColor,
              icon: Icon(
                Icons.more_vert,
                color: primaryColor,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Edit'),
                  onTap: () async {
                    DatabaseHelper.instance.getUpcomingTrip(widget.user.id!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTripScreen(
                          user: widget.user,
                          tripData: widget.trip,
                        ),
                      ),
                    );
                  },
                ),
                PopupMenuItem(
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    _deleteDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OngoingContainer(
              trip: widget.trip,
              coverPic: widget.trip.coverPic,
              destination: widget.trip.destination,
              startingDate: widget.trip.startingDate,
            ),
            SizedBox(
              height: screenSize.height * 0.03,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting date',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.002,
                  ),
                  Text(
                    widget.trip.startingDate,
                    style: TextStyle(color: accentColor3, fontSize: 13.5),
                  )
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Ending date',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.002,
                  ),
                  Text(
                    widget.trip.endingDate,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13.5,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.01,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: accentColor),
                  borderRadius: BorderRadius.circular(6)),
              height: screenSize.height * 0.05,
              width: screenSize.width * 0.9,
              child: Center(
                  child: Text(
                'Budget : ₹ ${widget.trip.budget}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
            ),
            SizedBox(
              height: screenSize.height * 0.03,
            ),
            Row(
              children: [
                Text(
                  'Travel purpose       ',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: accentColor2,
                      borderRadius: BorderRadius.circular(6)),
                  height: screenSize.height * 0.05,
                  width: screenSize.width * 0.3,
                  child: Center(
                      child: Text(
                    widget.trip.travelPurpose,
                    style: TextStyle(color: accentColor3),
                  )),
                )
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.01,
            ),
            Divider(),
            SizedBox(
              height: screenSize.height * 0.01,
            ),
            Text(
              'Companions',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
            ),
            Container(
              height: screenSize.height * 0.1,
              width: screenSize.width * 0.9,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.trip.companions.length,
                itemBuilder: (context, index) {
                  final companion = widget.trip.companions[index];
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 20, 0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              maxRadius: 22,
                              child: Text(
                                companion.name[0],
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: screenSize.height * 0.006,
                            ),
                            Text(
                              companion.name,
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteDialog(BuildContext context) async {
    DatabaseHelper.instance.getUpcomingTrip(widget.user.id!);
    showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Column(
          children: [
            Text("Delete your trip?"),
            Text(
              "Any drafts that you've saved will be deleted on this device",
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.normal),
            )
          ],
        ),
        actions: [
          CupertinoButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          CupertinoButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteTrip(widget.trip.id!);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      (bottomNavigationBar(userdata: widget.user)),
                ),
                (route) => false,
              );
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}