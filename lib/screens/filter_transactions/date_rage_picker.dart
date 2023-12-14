import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:just_expenses_clone/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePicker extends StatefulWidget {
  String range;
  bool isDateFiltered;
  DateRangePicker(this.range, this.isDateFiltered, {super.key});

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  String startDate = "Start Date";
  String endDate = "End Date";
  late DateTime fromDate, toDate;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate = dateFormat.format(args.value.startDate);
        endDate = dateFormat.format(args.value.endDate ?? args.value.startDate);
        fromDate = args.value.startDate;
        toDate = args.value.endDate ?? args.value.startDate;
        widget.range = "$startDate~$endDate";
      }
    });
  }

  @override
  void initState() {
    if (widget.isDateFiltered) {
      var split = widget.range.split("~");
      fromDate = dateFormat.parse(split[0]);
      toDate = dateFormat.parse(split[1]);
    } else {
      fromDate = DateTime.now();
      toDate = DateTime.now();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: kPrimaryColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, widget.range);
                      },
                      child: const Text("Save"))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(startDate),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(endDate)
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(fromDate, toDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
