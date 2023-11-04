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
import 'detail_tab.dart';
import 'expense_tab.dart';
import 'media_tab.dart';

class RecentTripScreen extends StatelessWidget {
  UserModal user;
  TripModal trip;
  RecentTripScreen({super.key, required this.user, required this.trip});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text(
            trip.tripName,
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
                      DatabaseHelper.instance.getRecentTrip(user.id!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTripScreen(
                                  user: user,
                                  tripData: trip,
                                )),
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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            children: [
              OngoingContainer(
                trip: trip,
                coverPic: trip.coverPic,
                destination: trip.destination,
                startingDate: trip.startingDate,
              ),
              TabBar(
                  indicatorColor: primaryColor,
                  padding: EdgeInsets.only(top: 10),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: primaryColor,
                  tabs: [
                    Tab(
                      text: 'Details',
                    ),
                    Tab(
                      text: 'Media',
                    ),
                    Tab(
                      text: 'Expenses',
                    ),
                  ]),
              Expanded(
                child: TabBarView(children: [
                  DetailTab(
                    user: user,
                    trip: trip,
                  ),
                  MediaTab(
                    trip: trip,
                  ),
                  ExpenseTab(trip: trip)
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteDialog(BuildContext context) async {
    DatabaseHelper.instance.getRecentTrip(user.id!);
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
              await DatabaseHelper.instance.deleteTrip(trip.id!);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => (bottomNavigationBar(userdata: user)),
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
