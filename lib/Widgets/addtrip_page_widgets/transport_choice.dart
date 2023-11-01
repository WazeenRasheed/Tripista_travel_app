import 'package:flutter/material.dart';
import '../../Components/styles.dart';
import '../../Screens/add_trip_screen.dart';

Map<String, dynamic> iconData = {
  'Flight': Icons.flight,
  'Car ': Icons.directions_car_rounded,
  'Train': Icons.train_rounded,
  'Bike': Icons.directions_bike_rounded,
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

  MyChoiceChip({Key? key}) : super(key: key);

  @override
  State<MyChoiceChip> createState() => _MyChoiceChipState();
}

class _MyChoiceChipState extends State<MyChoiceChip> {
  int? _value = 0;

  @override
  Widget build(BuildContext context) {

    return Wrap(
      spacing: 8,
      children: List.generate(
        widget.choices.length,
        (int index) {
          return Container(
            height: 50,
            width: 112,
            child: ChoiceChip(
              padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
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
