import 'package:flutter/material.dart';
import '../../Components/styles.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  final String description =
      'Tripista is your ultimate travel companion that lets you plan and organize your trips with ease. Whether you\'re a solo adventurer or traveling with friends and family, Tripista helps you create memorable journeys and keeps your travel budget on track.';
  final String privacy =
      'Your privacy is our priority. Refer to our privacy policy to understand how we safeguard your personal information.';
  final String features1 =
      'Trip Planning Made Easy: Seamlessly plan your trips by adding destinations, start and end dates, and purposes for each adventure.';
  final String features2 =
      'Budget Management: Set your trip budget and track expenses effortlessly. Tripista ensures you stay within your budget while making the most of your experiences.';
  final String features3 =
      'Expense Tracker: Log all your expenses during the trip, including food, transportation, accommodation, and more. Keep a detailed record of your spending.';
  final String features4 =
      'Companions Management: Invite travel companions to your trips and manage their information for better coordination.';
  final String features5 =
      'Interactive Maps: Visualize your trip routes and destinations on interactive maps for a better understanding of your journey.';
  final String features6 =
      'Customizable Itinerary: Create a personalized itinerary for each day of your trip, including activities, places to visit, and dining options.';
  final String features7 =
      'Travel Memories: Capture and store precious moments with photo and note entries for each destination you explore.';
  final String features8 =
      'Dark Mode Support: Enjoy a pleasant browsing experience during nighttime or in low-light conditions.';

  @override
  Widget build(BuildContext context) {
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
          'App Info',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        children: [
          customColumn(
              title: 'App Name', subtitle: ' Tripista', context: context),
          customColumn(
              title: 'Description', subtitle: description, context: context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Key features',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 15),
              features(features: features2),
              const SizedBox(height: 10),
              features(features: features3),
              const SizedBox(height: 10),
              features(features: features4),
              const SizedBox(height: 10),
              features(features: features5),
              const SizedBox(height: 10),
              features(features: features6),
              const SizedBox(height: 10),
              features(features: features7),
              const SizedBox(height: 10),
              features(features: features8)
            ],
          ),
          const SizedBox(height: 20),
          customColumn(
              title: 'Privacy Policy', subtitle: privacy, context: context),
        ],
      ),
    );
  }

  Row features({required String features}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.circle,
          size: 10,
          color: primaryColor,
        ),
        const SizedBox(width: 10),
        Expanded(
            child: Text(
          features,
          style: TextStyle(
              color: primaryColor,
              overflow: TextOverflow.clip),
          textAlign: TextAlign.left,
        ))
      ],
    );
  }

  Column customColumn(
      {required String title,
      required String subtitle,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
              color: primaryColor,
              overflow: TextOverflow.clip),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
