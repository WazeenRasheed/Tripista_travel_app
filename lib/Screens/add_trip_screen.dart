import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Components/custom_button.dart';
import '../Components/custom_textfield.dart';
import '../Components/styles.dart';
import '../Database/database_functions.dart';
import '../Database/models/trip_model.dart';
import '../Database/models/user_model.dart';
import '../Widgets/addtrip_page_widgets/companions.dart';
import '../Widgets/addtrip_page_widgets/cover_pic_container.dart';
import '../Widgets/addtrip_page_widgets/datepicker.dart';
import '../Widgets/addtrip_page_widgets/transport_choice.dart';
import '../Widgets/addtrip_page_widgets/travel_purpose.dart';
import 'bottom_navigation.dart';

String? selectedTransport;
String? selectedTravelPurpose;

class AddTripScreen extends StatefulWidget {
  final UserModal user;
  final TripModal? tripData;
  AddTripScreen({super.key, required this.user, this.tripData});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final formKey = GlobalKey<FormState>();
  final tripNameController = TextEditingController();
  final destinationController = TextEditingController();
  final budgetController = TextEditingController();
  final startingDateController = TextEditingController();
  final endingDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.tripData != null) {
      final tripData = widget.tripData!;
      tripNameController.text = tripData.tripName;
      destinationController.text = tripData.destination;
      budgetController.text = widget.tripData!.budget.toString();
      startingDateController.text = tripData.startingDate;
      endingDateController.text = tripData.endingDate;
      coverPic = File(tripData.coverPic!);

      selectedTransport = widget.tripData!.transport;
      selectedTravelPurpose = widget.tripData!.travelPurpose;

      companionList = tripData.companions.map((companion) {
        return {
          "name": companion.name,
          "number": companion.number,
        };
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: widget.tripData != null
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                ))
            : null,
        title: Text(
          widget.tripData == null ? ' Add new trip' : ' Edit your trip',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 23,
          ),
        ),
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //cover picture
                addTripCoverPicContainer(),
                SizedBox(
                  height: screenSize.height * 0.018,
                ),

                //trip name field
                myTextField(
                  controller: tripNameController,
                  hintText: 'Enter trip name',
                  validation: (value) {
                    if (value == null || value!.isEmpty) {
                      return 'Name required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.018,
                ),

                //trip destination field
                myTextField(
                  controller: destinationController,
                  hintText: 'Enter trip destination',
                  validation: (value) {
                    if (value == null || value!.isEmpty) {
                      return 'Destination required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.018,
                ),

                //trip budget field
                myTextField(
                  controller: budgetController,
                  hintText: 'Enter trip budget',
                  keyboardType: TextInputType.number,
                  validation: (value) {
                    if (value == null || budgetController.text.trim().isEmpty) {
                      return 'Please Enter your Budget';
                    } else if (value.contains(RegExp(r'[a-z]'))) {
                      return 'only Numbers allowed';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.018,
                ),

                // starting and ending date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenSize.width * 0.43,
                      child: MyDatePicker2(
                        dateCheck: true,
                        startController: startingDateController,
                        startOrend: 'Starting date',
                      ),
                    ),
                    Container(
                      width: screenSize.width * 0.43,
                      child: MyDatePicker2(
                        endController: endingDateController,
                        startOrend: 'Ending date',
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: screenSize.height * 0.018,
                ),
                Text('Choose preferred transport'),
                SizedBox(
                  height: screenSize.height * 0.018,
                ),

                //transport type
                MyChoiceChip(),
                SizedBox(
                  height: screenSize.height * 0.018,
                ),

                //trip type
                Text('Select travel purpose'),
                SizedBox(
                  height: screenSize.height * 0.018,
                ),
                MyDropdownMenu(
                  items: ['Business', 'Entertainment', 'Family', 'Other'],
                  initialValue: 'Business',
                ),
                SizedBox(
                  height: screenSize.height * 0.018,
                ),

                //companions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyCompanion(
                      context: context,
                      functionCheck: true,
                      text: '  Select companions',
                    ),
                    MyCompanion(
                      text: '  Show companions',
                      context: context,
                    )
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.018,
                ),

                MyButton(
                  backgroundColor: primaryColor,
                  text: widget.tripData == null ? 'Add' : 'Update',
                  textColor: backgroundColor,
                  onTap: () {
                    onButtonClicked();
                  },
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  onButtonClicked() async {
    if (formKey.currentState!.validate()) {
      if (coverPic == null) {
        // Show an error message if the image is not selected.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please add image before finishig the form.'),
            behavior: SnackBarBehavior.floating,
            // margin: EdgeInsets.all(20),
          ),
        );
        return;
      }
      final tripName = tripNameController.text.trim();
      final destination = destinationController.text.trim();
      int? budget = int.tryParse(budgetController.text);
      final startDate =
          DateFormat.yMMMd().parse(startingDateController.text.trim());
      final startingDate = DateFormat('yyyy-MM-dd').format(startDate);
      final endDate =
          DateFormat.yMMMd().parse(endingDateController.text.trim());
      final endingDate = DateFormat('yyyy-MM-dd').format(endDate);
      final userID = widget.user.id;

      final trip = TripModal(
        tripName: tripName,
        destination: destination,
        budget: budget ?? 0,
        startingDate: startingDate,
        endingDate: endingDate,
        transport: selectedTransport!,
        travelPurpose: selectedTravelPurpose!,
        coverPic: coverPic!.path,
        userID: userID,
        id: widget.tripData?.id,
      );
      print('Trip Details');
      print('data is $trip');

      if (widget.tripData != null) {
        await DatabaseHelper.instance.updateTrip(trip);
      } else {
        await DatabaseHelper.instance.addTrip(trip, companionList);
      }

      coverPic = null;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => (bottomNavigationBar(userdata: widget.user)),
        ),
        (route) => false,
      );
    }
  }
}
