// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Components/styles.dart';

class MyDatePicker2 extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  TextEditingController? startController;
  TextEditingController? endController;
  final TextInputType? keyboardType;
  FormFieldValidator? validation;
  final String startOrend;
  final bool dateCheck;

  MyDatePicker2(
      {super.key,
      this.dateCheck = false,
      this.startController,
      this.endController,
      this.keyboardType,
      this.validation,
      required this.startOrend});

  @override
  State<MyDatePicker2> createState() => _myTextFieldState();
}

class _myTextFieldState extends State<MyDatePicker2> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        widget.dateCheck ? _showStartDate(context) : _showEndDate(context);
      },
      readOnly: true,
      controller:
          widget.dateCheck ? widget.startController : widget.endController,
      keyboardType: widget.keyboardType,
      validator: widget.validation,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_month),
        contentPadding: //textfield height
            EdgeInsets.symmetric(vertical: 17, horizontal: 20),
        hintText: '${widget.startOrend}',
        // labelStyle: TextStyle(fontSize: 15, color: accentColor),
        hintStyle: TextStyle(color: accentColor, fontSize: 15),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color: primaryColor,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: primaryColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.red)),
      ),
    );
  }

  _showStartDate(BuildContext context) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        if (value == null) {
          return;
        } else {
          widget.startController?.text = DateFormat.yMMMd().format(value);
        }
      });
    });
  }

  _showEndDate(BuildContext context) async {
    selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        if (value == null) {
          return;
        } else {
          widget.endController?.text = DateFormat.yMMMd().format(value);
        }
      });
    });
  }
}
