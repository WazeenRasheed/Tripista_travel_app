// ignore_for_file: unused_field
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Components/styles.dart';
import '../Database/database_functions.dart';
import '../Database/models/trip_model.dart';
import '../Database/models/user_model.dart';
import '../Widgets/home_page_widgets/empty_trip_container.dart';
import '../Widgets/home_page_widgets/ongoing_container.dart';
import '../Widgets/home_page_widgets/trip_title.dart';
import '../Widgets/home_page_widgets/upcoming_recent_container.dart';
import 'subscreens_home/ongoing_trip.dart';
import 'subscreens_home/recent_trip.dart';
import 'subscreens_home/upcoming_trip.dart';

class HomeScreen extends StatefulWidget {
  final UserModal user;
  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _upcomingPageController = PageController();
  PageController _recentPageController = PageController();
  int _upcomingCurrentPage = 0;
  int _recentCurrentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await DatabaseHelper.instance.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // profile pic AND name
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: FutureBuilder(
                    future: DatabaseHelper.instance.getLogedProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error ${snapshot.error}");
                      }
                      final user = snapshot.data;
                      return CircleAvatar(
                        maxRadius: 23,
                        backgroundImage: FileImage(File(user?['image'])),
                      );
                    },
                  ),
                  title: FutureBuilder(
                    future: DatabaseHelper.instance.getLogedProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error ${snapshot.error}");
                      }
                      final user = snapshot.data;
                      return Text(
                        'Hi, ${user?['name']}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenSize.height * 0.025),

                //ongoing trip
                HomeText(text: 'Ongoing trip'),
                SizedBox(height: screenSize.height * 0.02),
                FutureBuilder(
                  future:
                      DatabaseHelper.instance.getOnGoingTrip(widget.user.id!),
                  builder: (context, snapshot) {
                    final tripData = snapshot.data;
                    return tripData == null
                        ? EmptyTripContainer(
                            user: widget.user,
                            addIcon: Icons.add_circle_outline,
                            text1: "You don't have ongoing trip",
                            text2: "Add your trip now!")
                        : OngoingContainer(
                            trip: tripData,
                            coverPic: tripData.coverPic,
                            destination: tripData.destination,
                            startingDate: tripData.startingDate,
                            transportIcon: tripData.transport,
                            onTap: () async {
                              await DatabaseHelper.instance
                                  .getExpense(tripData.id!);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OngoingTripScreen(
                                    user: widget.user,
                                    trip: tripData,
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
                SizedBox(height: screenSize.height * 0.03),

                //Upcoming trips
                FutureBuilder(
                  future:
                      DatabaseHelper.instance.getUpcomingTrip(widget.user.id!),
                  builder: (context, snapshot) {
                    final List<TripModal>? trips = snapshot.data;
                    return trips != null
                        ? Row(
                            children: [
                              HomeText(text: 'Upcoming trips'),
                              SizedBox(width: screenSize.width * 0.02),
                              trips.length == 0
                                  ? SizedBox()
                                  : CircleAvatar(
                                      maxRadius: 10,
                                      backgroundColor: accentColor2,
                                      child: Text(
                                        '${trips.length}',
                                        style: TextStyle(
                                            color: accentColor3, fontSize: 12),
                                      ),
                                    )
                            ],
                          )
                        : SizedBox();
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),
                FutureBuilder(
                  future:
                      DatabaseHelper.instance.getUpcomingTrip(widget.user.id!),
                  builder: (context, snapshot) {
                    final List<TripModal>? trips = snapshot.data;
                    return trips == null || trips.isEmpty
                        ? EmptyTripContainer(
                            user: widget.user,
                            addIcon: Icons.add_circle_outline,
                            text1: "You don't have any upcoming trips",
                            text2: "Add your trip now!")
                        : Column(
                            children: [
                              SizedBox(
                                height: screenSize.height * 0.20,
                                child: PageView.builder(
                                  controller: _upcomingPageController,
                                  itemCount: trips.length,
                                  itemBuilder: (context, index) {
                                    final TripModal tripData = trips[index];
                                    return UpcomingRecentContainer(
                                      tripData: tripData,
                                      coverPic: tripData.coverPic,
                                      destination: tripData.destination,
                                      startingDate: tripData.startingDate,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpcomingTripScreen(
                                              user: widget.user,
                                              trip: tripData,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _upcomingCurrentPage = page;
                                    });
                                  },
                                ),
                              ),
                              trips.length > 1
                                  ? SizedBox(
                                      height: screenSize.height * 0.025,
                                      child: SmoothPageIndicator(
                                        controller: _upcomingPageController,
                                        count: trips.length,
                                        effect: WormEffect(
                                          spacing: 5,
                                          dotWidth: 7,
                                          dotHeight: 7,
                                          activeDotColor: primaryColor,
                                          dotColor:
                                              accentColor.withOpacity(0.6),
                                        ),
                                      ))
                                  : SizedBox()
                            ],
                          );
                  },
                ),
                SizedBox(height: screenSize.height * 0.03),

                //Recent trips
                FutureBuilder(
                  future:
                      DatabaseHelper.instance.getRecentTrip(widget.user.id!),
                  builder: (context, snapshot) {
                    final List<TripModal>? trips = snapshot.data;
                    return trips != null
                        ? Row(
                            children: [
                              HomeText(text: 'Recent trips'),
                              SizedBox(width: screenSize.width * 0.02),
                              trips.length == 0
                                  ? SizedBox()
                                  : CircleAvatar(
                                      maxRadius: 10,
                                      backgroundColor: accentColor2,
                                      child: Text(
                                        '${trips.length}',
                                        style: TextStyle(
                                            color: accentColor3, fontSize: 12),
                                      ),
                                    )
                            ],
                          )
                        : SizedBox();
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),
                FutureBuilder(
                  future:
                      DatabaseHelper.instance.getRecentTrip(widget.user.id!),
                  builder: (context, snapshot) {
                    final List<TripModal>? trips = snapshot.data;
                    return trips == null || trips.isEmpty
                        ? EmptyTripContainer(
                            user: widget.user,
                            text1: "You don't have any recent trips :(",
                            textStyle: TextStyle(fontSize: 13),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: screenSize.height * 0.20,
                                child: PageView.builder(
                                  controller: _recentPageController,
                                  itemCount: trips.length,
                                  itemBuilder: (context, index) {
                                    final TripModal tripData = trips[index];
                                    return UpcomingRecentContainer(
                                      tripData: tripData,
                                      coverPic: tripData.coverPic,
                                      destination: tripData.destination,
                                      startingDate: tripData.startingDate,
                                      onTap: () async {
                                        await DatabaseHelper.instance
                                            .getExpense(tripData.id!);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RecentTripScreen(
                                              user: widget.user,
                                              trip: tripData,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _recentCurrentPage = page;
                                    });
                                  },
                                ),
                              ),
                              trips.length > 1
                                  ? SizedBox(
                                      height: screenSize.height * 0.025,
                                      child: SmoothPageIndicator(
                                        controller: _recentPageController,
                                        count: trips.length,
                                        effect: WormEffect(
                                          spacing: 5,
                                          dotWidth: 7,
                                          dotHeight: 7,
                                          activeDotColor: primaryColor,
                                          dotColor:
                                              accentColor.withOpacity(0.6),
                                        ),
                                      ))
                                  : SizedBox()
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
