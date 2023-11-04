import 'dart:io';
import 'package:flutter/material.dart';
import '../Components/styles.dart';
import '../Database/database_functions.dart';
import '../Database/models/trip_model.dart';
import '../Database/models/user_model.dart';
import 'subscreens_home/ongoing_trip.dart';

class SearchScreen extends StatefulWidget {
  final UserModal user;
  SearchScreen({super.key, required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  List<TripModal> filteredList = [];
  List<TripModal> userTrips = [];
  bool notFound = false;

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.getAllTrip().then((value) {
      setState(() {
        userTrips = value;
        filteredList = userTrips;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      filteredList = userTrips
                          .where((trip) => trip.destination
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                      if (filteredList.isEmpty) {
                        notFound = true;
                      }
                      if (value.isEmpty) {
                        filteredList = userTrips;
                        notFound = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                      //search icon
                      prefixIcon: Icon(
                        Icons.search,
                        size: 22,
                        color: Colors.black45,
                      ),
                      // clear icon
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              searchController.text = '';
                              filteredList = userTrips;
                              notFound = false;
                            });
                          },
                          child: Icon(Icons.cancel, size: 22)),
                      contentPadding: //textfield size
                          EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      hintText: 'Search trips',
                      hintStyle: TextStyle(color: Colors.black54),
                      fillColor: backgroundColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: accentColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: accentColor))),
                ),
                SizedBox(
                  height: screenSize.height * 0.03,
                ),
                Container(
                  child: filteredList.isEmpty
                      ? Container(
                          height: screenSize.height * 0.75,
                          width: double.maxFinite,
                          alignment: Alignment.center,
                          child: notFound
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: screenSize.height * 0.1,
                                    ),
                                    Text('No trip found'),
                                  ],
                                )
                              : Text("You don't have any trips for search !"))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final trip = filteredList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OngoingTripScreen(
                                        trip: trip, user: widget.user),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: accentColor4,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: trip.coverPic != null
                                        ? FileImage(File(trip.coverPic!))
                                        : null,
                                  ),
                                  title: Text(
                                    trip.tripName,  
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    trip.startingDate,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 15,
                            );
                          },
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
