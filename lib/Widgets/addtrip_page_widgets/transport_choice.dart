import 'package:flutter/material.dart';
import '../../Components/styles.dart';
import '../../Screens/add_trip_screen.dart';

Map<String, dynamic> iconData = {
  'Flight': Icons.flight,
  'Car ': Icons.directions_car_rounded,
  'Train': Icons.train_rounded,
  'Bike  ': Icons.directions_bike_rounded,
  'Ship': Icons.directions_boat,
  'Other': Icons.commute
};

class MyChoiceChip extends StatefulWidget {
  final List<String> choices = [
    'Flight',
    'Car ',
    'Train',
    'Bike  ',
    'Ship',
    'Other'
  ];
  final List<Icon> icons = [
    Icon(Icons.flight),
    Icon(Icons.directions_car_rounded),
    Icon(Icons.train_rounded),
    Icon(Icons.directions_bike_rounded),
    Icon(Icons.directions_boat),
    Icon(Icons.commute),
  ];

  MyChoiceChip({Key? key, this.selectedTransport}) : super(key: key);
  final String? selectedTransport;

  @override
  State<MyChoiceChip> createState() => _MyChoiceChipState();
}

class _MyChoiceChipState extends State<MyChoiceChip> {
  int? _value;

  void initState() {
    super.initState();
    if (widget.selectedTransport != null) {
      _value = widget.choices.indexOf(widget.selectedTransport!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Wrap(
      spacing: screenSize.width * 0.018,
      runSpacing: screenSize.height * 0.005,
      children: List.generate(
        widget.choices.length,
        (int index) {
          return Container(
            height: screenSize.height * 0.06,
            width: screenSize.width * 0.287,
            child: ChoiceChip(
              showCheckmark: false,
              padding: EdgeInsets.fromLTRB(
                screenSize.width * 0.06,
                screenSize.height * 0.013,
                screenSize.width * 0.06,
                screenSize.height * 0.013,
              ),
              avatar: widget.icons[index],
              selectedColor: primaryColor,
              backgroundColor: backgroundColor,
              iconTheme: IconThemeData(
                color: accentColor,
                size: 17,
              ),
              labelStyle: TextStyle(color: accentColor, fontSize: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(width: 1)),
              label: Text(widget.choices[index]),
              selected: _value == index,
              onSelected: (bool selected) {
                setState(() {
                  _value = selected ? index : null;
                  _value != null
                      ? selectedTransport = widget.choices[_value!]
                      : null;
                });
              },
            ),
          );
        },
      ).toList(),
    );
  }
}
