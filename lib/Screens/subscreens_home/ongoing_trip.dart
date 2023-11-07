// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import '../../Components/custom_dialog.dart';
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

class OngoingTripScreen extends StatelessWidget {
  final UserModal user;
  final TripModal trip;

  OngoingTripScreen({Key? key, required this.user, required this.trip})
      : super(key: key);

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
                      DatabaseHelper.instance.getOnGoingTrip(user.id!);
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
                      customDialog(
                        context: context,
                        text: 'Delete your trip?',
                        subText:
                            "This ongoing trip data will be deleted on this device",
                        signOrClear: 'Delete',
                        onPressed: () async {
                          await DatabaseHelper.instance.deleteTrip(trip.id!);
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  bottomNavigationBar(userdata: user),
                            ),
                            (route) => false,
                          );
                        },
                      );
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
                  ExpenseTab(
                    trip: trip,
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
