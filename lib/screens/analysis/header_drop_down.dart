import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/utils.dart';

class HeaderDropDownWidget extends StatefulWidget {
  Function(String selectedSlot) filterSlots;
  String dropdownValue;
  HeaderDropDownWidget(
    this.filterSlots,
    this.dropdownValue, {
    Key? key,
  }) : super(key: key);

  @override
  State<HeaderDropDownWidget> createState() => _HeaderDropDownWidgetState();
}

class _HeaderDropDownWidgetState extends State<HeaderDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    List<String> spinnerItems = ['All Time', 'Daily', 'Monthly', 'Yearly'];

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: Utils.getProportionalHeight(context, 0.035),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.dropdownValue,
          iconSize: 0.0,
          style: const TextStyle(color: kTextColorBlue),
          onChanged: (value) {
            widget.filterSlots(value!);
          },
          items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 15),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
