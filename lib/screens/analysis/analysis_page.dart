import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_expenses_clone/constants.dart';
import 'package:just_expenses_clone/data/database_helper.dart';
import 'package:just_expenses_clone/screens/analysis/header_drop_down.dart';
import 'package:just_expenses_clone/screens/model/cat_transaction.dart';
import 'package:just_expenses_clone/screens/model/transaction.dart';

import '../../utils/utils.dart';
import '../model/categories.dart';
import 'analysis_cat_listing.dart';
import 'expense_card_widget.dart';
import 'income_card_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class _AnalysisPageState extends State<AnalysisPage> {
  final List<_ChartData> data = [];
  final List<CatTransaction> listCatTransaction = [];
  late TooltipBehavior _tooltip;
  late DatabaseHelper databaseHelper;
  DateTime dateTime = DateTime.now();
  String averageText = "Annual Average";
  String selectedSlot = "All Time";
  String currencySymbol = "";

  double averageIncomeAmount = 0;
  double averageExpenseAmount = 0;

  int grandTotal = 0;
  int income = 0;
  int expense = 0;

  @override
  void initState() {
    databaseHelper = DatabaseHelper();
    getDonutChartData();
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  getDonutChartData() {
    data.clear();
    listCatTransaction.clear();
    grandTotal = 0;
    income = 0;
    expense = 0;
    databaseHelper.retriveCategories().then((categories) {
      databaseHelper
          .retriveTransactions()
          .then((transaction) => {parseData(categories, transaction)});
    });
  }

  calculateAmount(transactions) {
    for (var element in transactions) {
      if (element.type == "inc") {
        income = element.amount!.toInt() + income;
      }
      if (element.type == "exp") {
        expense = element.amount!.toInt() + expense;
      }
    }

    grandTotal = income - expense;
  }

  parseData(List<Categories> categories, List<TransactionModel> transactions) {
    averageIncomeAmount = 0;
    averageExpenseAmount = 0;

    calculateAmount(transactions);

    if (selectedSlot == "Daily") {
      String startOfDay =
          DateTime(dateTime.year, dateTime.month, dateTime.day).toString();

      transactions = transactions
          .where((element) => element.submitted == startOfDay)
          .toList();

      averageText = "Annual Average";
    } else if (selectedSlot == "Monthly") {
      transactions = transactions.where(
        (element) {
          int tMonth = DateFormat("yyyy-MM-dd").parse(element.submitted!).month;
          int currentMonth = dateTime.month;
          return tMonth == currentMonth;
        },
      ).toList();

      averageText = "Daily Average";
      var dateParse = DateTime(dateTime.year, dateTime.month + 1, 0);
      averageIncomeAmount = income / dateParse.day;
    } else if (selectedSlot == "Yearly") {
      transactions = transactions.where(
        (element) {
          int tYear = DateFormat("yyyy-MM-dd").parse(element.submitted!).year;
          int currentYear = dateTime.year;
          return tYear == currentYear;
        },
      ).toList();

      averageText = "Monthly Average";
      averageExpenseAmount = expense / 12;
    }

    calculateCategoryList(categories, transactions);

    setState(() {});
  }

  calculateCategoryList(categories, List<TransactionModel> transactions) {
    for (var cat in categories) {
      double finalAmount = 0.0;
      String category = "";
      String catId = "";
      String transactionId = "";
      String icon = "";

      for (var transaction in transactions) {
        if (transaction.categoryId == cat.id.toString()) {
          finalAmount = transaction.amount! + finalAmount;
          category = cat.title!;
          catId = cat.id.toString();
          transactionId = transaction.id.toString();
          icon = cat.icon!;
        }
        currencySymbol = transaction.currencySymbol ?? "";
      }
      if (finalAmount != 0) {
        listCatTransaction.add(CatTransaction(
            catId: catId,
            transactionId: transactionId,
            totalAmount: finalAmount,
            color: cat.color,
            categoryTitle: category,
            icon: icon,
            currencySymbol: currencySymbol));
        data.add(_ChartData(category, finalAmount));
      }
    }
  }

  filterSlots(String slot) {
    setState(() {
      selectedSlot = slot;
    });
    dateTime = DateTime.now();
    getDonutChartData();
  }

  formatDailyDate(String type) {
    setState(() {
      if (type == 'plus') {
        if (selectedSlot == "Daily") {
          dateTime = dateTime.add(Duration(days: 1));
        } else if (selectedSlot == "Monthly") {
          dateTime = DateTime(dateTime.year, dateTime.month + 1, dateTime.day);
        } else if (selectedSlot == "Yearly") {
          dateTime = DateTime(dateTime.year + 1, dateTime.month, dateTime.day);
        }
      } else {
        if (selectedSlot == "Daily") {
          dateTime = dateTime.subtract(Duration(days: 1));
        } else if (selectedSlot == "Monthly") {
          dateTime = DateTime(dateTime.year, dateTime.month - 1, dateTime.day);
        } else if (selectedSlot == "Yearly") {
          dateTime = DateTime(dateTime.year - 1, dateTime.month, dateTime.day);
        }
      }
    });
    getDonutChartData();
  }

  String printFormattedDate() =>
      "${DateFormat('d', "en_US").format(dateTime)} ${DateFormat('E', "en_US").format(dateTime)}";

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
                height: Utils.getProportionalHeight(context, 0.050),
              ),
              Text(
                currencySymbol + grandTotal.toString(),
                style: const TextStyle(fontSize: 26, color: Colors.white),
              ),
              SizedBox(
                height: Utils.getProportionalHeight(context, 0.015),
              ),
              const Text("Total balance for selected period",
                  style: TextStyle(color: Colors.white)),
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
                          child: HeaderDropDownWidget(
                            filterSlots,
                            selectedSlot,
                          ),
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
      body: SingleChildScrollView(
        child: listCatTransaction.isEmpty
            ? const Center(
                child: Text("No Data Found"),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 30.0),
                    child: Row(
                      children: const [
                        Expanded(flex: 1, child: Text("INCOME")),
                        Expanded(flex: 1, child: Text("EXPENSE")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      children: [
                        IncomeCardWidget(income, averageIncomeAmount,
                            averageText, currencySymbol),
                        const SizedBox(
                          width: 10,
                        ),
                        ExpenseCardWidget(expense, averageExpenseAmount,
                            averageText, currencySymbol),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: data != null
                        ? Card(
                            color: Colors.white,
                            child: SfCircularChart(
                              tooltipBehavior: _tooltip,
                              legend: Legend(
                                  isVisible: true,
                                  overflowMode: LegendItemOverflowMode.wrap),
                              series: <CircularSeries<_ChartData, String>>[
                                DoughnutSeries<_ChartData, String>(
                                  dataSource: data,
                                  startAngle: 0,
                                  endAngle: 360,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                  enableTooltip: true,
                                  xValueMapper: (_ChartData data, _) => data.x,
                                  yValueMapper: (_ChartData data, _) => data.y,
                                )
                              ],
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  AnalysisCatListing(listCatTransaction)
                ],
              ),
      ),
    );
  }
}
