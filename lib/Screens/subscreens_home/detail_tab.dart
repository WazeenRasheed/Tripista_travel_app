import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/styles.dart';
import '../../Database/database_functions.dart';
import '../../Database/models/trip_model.dart';
import '../../Database/models/user_model.dart';
import '../../Widgets/detailtab_budget_container.dart';

class DetailTab extends StatelessWidget {
  final UserModal user;
  final TripModal trip;
  DetailTab({Key? key, required this.user, required this.trip});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.5),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.002,
                    ),
                    Text(
                      trip.startingDate,
                      style: TextStyle(color: accentColor3, fontSize: 13.5),
                    )
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Ending date',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.5),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.002,
                    ),
                    Text(
                      trip.endingDate,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13.5,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BudgetContainer(
                    text: 'Budget',
                    budgetORexpenses: '₹ ${trip.budget}',
                  ),
                  ValueListenableBuilder(
                    valueListenable: totalExpenses,
                    builder: (context, value, child) {
                      return BudgetContainer(
                        text: 'Expenses',
                        budgetORexpenses: '₹ $value',
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.023,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: accentColor),
                    borderRadius: BorderRadius.circular(6)),
                height: screenSize.height * 0.05,
                width: screenSize.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Balance : ',
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ValueListenableBuilder(
                      valueListenable: balanceNotifire,
                      builder: (context, value, child) => Text(
                        '₹ $value',
                        style: TextStyle(
                            fontSize: 18,
                            color: value <= 0 ? Colors.red : primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.03,
              ),
              Row(
                children: [
                  Text(
                    'Travel purpose       ',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: accentColor2,
                        borderRadius: BorderRadius.circular(6)),
                    height: screenSize.height * 0.05,
                    width: screenSize.width * 0.3,
                    child: Center(
                        child: Text(
                      trip.travelPurpose,
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
                  itemCount: trip.companions.length,
                  itemBuilder: (context, index) {
                    final companion = trip.companions[index];
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 20, 0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri(
                                      scheme: 'tel', path: companion.number);
                                  await launchUrl(url);
                                },
                                child: CircleAvatar(
                                  maxRadius: 22,
                                  child: Text(
                                    companion.name[0],
                                    style: TextStyle(fontSize: 20),
                                  ),
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
        ));
  }
}
