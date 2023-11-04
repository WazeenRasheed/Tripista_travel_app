import 'package:flutter/material.dart';

import '../../Components/styles.dart';
import '../../Screens/add_trip_screen.dart';

class MyDropdownMenu extends StatefulWidget {
  final List<String> items;
  final String initialValue;

  MyDropdownMenu({Key? key,required this.items,required this.initialValue}) : super(key: key);

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.06,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: primaryColor),
          borderRadius: BorderRadius.circular(6)),
      child: DropdownButton(
        
        dropdownColor: Color.fromARGB(255, 230, 230, 230),
        borderRadius: BorderRadius.circular(6),
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 15),
        underline: SizedBox(),
        isExpanded: true,
        value: dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            selectedTravelPurpose = dropdownValue;
          });
        },
        items: widget.items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }
}
