import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_expenses_clone/constants.dart';
import 'package:just_expenses_clone/data/database_helper.dart';
import 'package:just_expenses_clone/screens/analysis/header_drop_down.dart';
import 'package:just_expenses_clone/screens/model/transaction.dart';

import '../../utils/utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysisDetailPage extends StatefulWidget {
  String catId, categoryTitle, color;

  AnalysisDetailPage(this.catId, this.color, this.categoryTitle, {super.key});

  @override
  _AnalysisDetailPageState createState() => _AnalysisDetailPageState();
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}

class _AnalysisDetailPageState extends State<AnalysisDetailPage> {
  final List<_ChartData> data = [];
  List<TransactionModel> transactionList = [];
  late DatabaseHelper databaseHelper;
  DateTime dateTime = DateTime.now();
  String averageText = "Annual Average";
  String selectedSlot = "All Time";
  String currencySymbol = "";
  int grandTotal = 0;

  @override
  void initState() {
    databaseHelper = DatabaseHelper();
    getCartesianChartData();
    super.initState();
  }

  getCartesianChartData() {
    data.clear();
    transactionList.clear();
    grandTotal = 0;
    databaseHelper
        .retriveTransactionsByCatId(widget.catId)
        .then((transaction) => {parseData(transaction)});
  }

  calculateAmount(List<TransactionModel> transactions) {
    for (var element in transactions) {
      currencySymbol = element.currencySymbol ?? "";
      grandTotal = element.amount!.toInt() + grandTotal;
      String tag = DateFormat('d MMM', "en_US")
          .format(DateTime.parse(element.submitted!));
      data.add(_ChartData(tag, element.amount!.toInt()));
    }
  }

  parseData(List<TransactionModel> transactions) {
    calculateAmount(transactions);
    if (selectedSlot == "All Time") {
      transactionList = transactions;
    } else if (selectedSlot == "Daily") {
      String startOfDay =
          DateTime(dateTime.year, dateTime.month, dateTime.day).toString();

      transactionList = transactions
          .where((element) => element.submitted == startOfDay)
          .toList();
    } else if (selectedSlot == "Monthly") {
      transactionList = transactions.where(
        (element) {
          int tMonth = DateFormat("yyyy-MM-dd").parse(element.submitted!).month;
          int currentMonth = dateTime.month;
          return tMonth == currentMonth;
        },
      ).toList();
    } else if (selectedSlot == "Yearly") {
      transactionList = transactions.where(
        (element) {
          int tYear = DateFormat("yyyy-MM-dd").parse(element.submitted!).year;
          int currentYear = dateTime.year;
          return tYear == currentYear;
        },
      ).toList();
    }

    setState(() {});
  }

  filterSlots(String slot) {
    setState(() {
      selectedSlot = slot;
    });
    dateTime = DateTime.now();
    getCartesianChartData();
  }

  formatDailyDate(String type) {
    setState(() {
      if (type == 'plus') {
        if (selectedSlot == "Daily") {
          dateTime = dateTime.add(const Duration(days: 1));
        } else if (selectedSlot == "Monthly") {
          dateTime = DateTime(dateTime.year, dateTime.month + 1, dateTime.day);
        } else if (selectedSlot == "Yearly") {
          dateTime = DateTime(dateTime.year + 1, dateTime.month, dateTime.day);
        }
      } else {
        if (selectedSlot == "Daily") {
          dateTime = dateTime.subtract(const Duration(days: 1));
        } else if (selectedSlot == "Monthly") {
          dateTime = DateTime(dateTime.year, dateTime.month - 1, dateTime.day);
        } else if (selectedSlot == "Yearly") {
          dateTime = DateTime(dateTime.year - 1, dateTime.month, dateTime.day);
        }
      }
    });
    getCartesianChartData();
  }

  String printFormattedDate() =>
      "${DateFormat('d', "en_US").format(dateTime)} ${DateFormat('E', "en_US").format(dateTime)}";

  String printFormattedDayMonth(String submitted) {
    DateTime dateTime = DateTime.parse(submitted);
    return "${DateFormat('EEE', "en_US").format(dateTime)} , ${DateFormat('d', "en_US").format(dateTime)} ${DateFormat('MMM', "en_US").format(dateTime)}";
  }

  String printFormattedMonth() => DateFormat('MMM', "en_US").format(dateTime);

  String printFormattedYear() => DateFormat.y("en_US").format(dateTime);

  filterText(selectedSlot) {
    if (selectedSlot == "Daily") {
      return Text(printFormattedDate());
    } else if (selectedSlot == "Monthly") {
      return Text(printFormattedMonth());
    } else if (selectedSlot == "Yearly") {
      return Text(printFormattedYear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroudColor,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(Utils.getProportionalHeight(context, 0.15)),
        child: Container(
          color: primarySwatch,
          child: Column(
            children: [
              SizedBox(
                height: Utils.getProportionalHeight(context, 0.032),
              ),
              Text(
                widget.categoryTitle,
                style: const TextStyle(fontSize: 26, color: Colors.white),
              ),
              SizedBox(
                height: Utils.getProportionalHeight(context, 0.015),
              ),
              Text(currencySymbol + grandTotal.toString(),
                  style: const TextStyle(color: Colors.white)),
              SizedBox(
                height: Utils.getProportionalHeight(context, 0.020),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: Utils.getPreportionalWidth(context, 0.05)),
                          child:
                              HeaderDropDownWidget(filterSlots, selectedSlot),
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      children: [
                        if (selectedSlot != "All Time") ...[
                          Padding(
                            padding: EdgeInsets.only(
                                right:
                                    Utils.getPreportionalWidth(context, 0.15)),
                            child: Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height:
                                  Utils.getProportionalHeight(context, 0.035),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      formatDailyDate("minus");
                                    },
                                    child: const Icon(
                                      Icons.chevron_left,
                                      color: primarySwatch,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  filterText(selectedSlot),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      formatDailyDate("plus");
                                    },
                                    child: const Icon(
                                      Icons.chevron_right,
                                      color: primarySwatch,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: transactionList.isEmpty
          ? const Center(
              child: Text("No Data Found"),
            )
          : Column(
              children: [
                if (selectedSlot != "Daily") ...[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SfCartesianChart(
                          primaryYAxis: NumericAxis(interval: 10),
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries<_ChartData, String>>[
                            ColumnSeries<_ChartData, String>(
                                dataSource: data,
                                xValueMapper: (_ChartData data, _) => data.x,
                                yValueMapper: (_ChartData data, _) => data.y),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: transactionList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: Colors.grey, blurRadius: 2.0)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        widget.color.replaceAll('#', '0xff'))),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/calendar.png',
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      printFormattedDayMonth(
                                          transactionList[index].submitted!),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                (transactionList[index].currencySymbol ?? "") +
                                    transactionList[index].amount.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(transactionList[index].time!),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
    );
  }
}
