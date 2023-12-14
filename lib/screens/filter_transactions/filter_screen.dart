import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_expenses_clone/constants.dart';
import 'package:just_expenses_clone/screens/filter_transactions/date_rage_picker.dart';
import 'package:just_expenses_clone/screens/model/categories.dart';
import '../../data/database_helper.dart';
import '../../utils/utils.dart';
import '../model/cat_filter.dart';

class FilterScreen extends StatefulWidget {
  String fromAmount, toAmount;
  String fromDate, toDate;
  String catIds;
  bool isDateFiltered;
  FilterScreen(this.fromAmount, this.toAmount, this.fromDate, this.toDate,
      this.isDateFiltered, this.catIds,
      {super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int fromAmount = 0, toAmount = 0;
  late DateTime fromDate, toDate;
  List<CatFilter> categoryList = [];
  List<CatFilter> checkedCategoryList = [];
  String categoryFiltered = "Filter not set yet";
  TextEditingController fromAmountController = TextEditingController();
  TextEditingController toAmountController = TextEditingController();

  final _databaseHelper = DatabaseHelper();
  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  setInitialData() async {
    fromAmount = int.parse(widget.fromAmount);
    toAmount = int.parse(widget.toAmount);
    fromAmountController.text = fromAmount == 0 ? "" : fromAmount.toString();
    toAmountController.text = toAmount == 0 ? "" : toAmount.toString();

    if (widget.fromDate.isNotEmpty) {
      fromDate = DateTime.parse(widget.fromDate);
      toDate = DateTime.parse(widget.toDate);
    }

    List<Categories> categories = await _databaseHelper.retriveCategories();
    for (var element in categories) {
      categoryList
          .add(CatFilter(element.id, element.title, element.icon, false));
    }

    for (var element1 in categoryList) {
      for (var element in widget.catIds.split(",")) {
        if (element1.id.toString() == element.toString()) {
          element1.isChecked = true;
          checkedCategoryList.add(element1);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroudColor,
      appBar: AppBar(
        title: const Text("Filter"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(top: 10),
                child: const Text("AMOUNT RANGE"),
              ),
              InkWell(
                onTap: () => _amountRangeDialog(context),
                child: Container(
                  width: double.infinity,
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
                  child: Row(
                    children: [
                      Visibility(
                          visible:
                              fromAmount == 0 && toAmount == 0 ? true : false,
                          child: const Text("Filter Not set yet")),
                      Visibility(
                        visible: fromAmount == 0 ? false : true,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                          decoration: const BoxDecoration(
                              color: lightPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Row(
                            children: [
                              Text(">= $fromAmount"),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    fromAmount = 0;
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: kPrimaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Visibility(
                        visible: toAmount == 0 ? false : true,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                          decoration: const BoxDecoration(
                              color: lightPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Row(
                            children: [
                              Text("<= $toAmount"),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    toAmount = 0;
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: kPrimaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(top: 10),
                child: const Text("DATE RANGE"),
              ),
              InkWell(
                onTap: () => _navigateToDatePicker(context),
                child: Container(
                  width: double.infinity,
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
                  child: Row(
                    children: [
                      Visibility(
                          visible: widget.isDateFiltered ? false : true,
                          child: const Text("Filter Not set yet")),
                      Visibility(
                        visible: widget.isDateFiltered ? true : false,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                          decoration: const BoxDecoration(
                              color: lightPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Row(
                            children: [
                              Text(
                                  "${DateFormat("dd").format(fromDate)} - ${DateFormat("dd MMM").format(toDate)}"),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    widget.isDateFiltered = false;
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: kPrimaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(top: 10),
                child: const Text("CATEGORIES"),
              ),
              InkWell(
                onTap: () async {
                  var result = await _displayCatAlertDialog();
                  if (result) {
                    setState(() {});
                  }
                },
                child: Container(
                  width: double.infinity,
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
                  child: checkedCategoryList.isEmpty
                      ? const Text("Filter Not set yet")
                      : SizedBox(
                          width: double.infinity,
                          height: Utils.getProportionalHeight(context, 0.03),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: checkedCategoryList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 5, 10, 5),
                                decoration: const BoxDecoration(
                                    color: lightPrimaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Row(
                                  children: [
                                    Text(checkedCategoryList[index].title!),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (categoryList.contains(
                                              checkedCategoryList[index])) {
                                            categoryList
                                                .where((element) =>
                                                    element.title ==
                                                    checkedCategoryList[index]
                                                        .title)
                                                .first
                                                .isChecked = false;
                                          }
                                          checkedCategoryList.removeAt(index);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 18,
                                        color: kPrimaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: ElevatedButton.icon(
              onPressed: () {
                var buffer = StringBuffer();
                checkedCategoryList = checkedCategoryList.toSet().toList();
                for (int i = 0; i < checkedCategoryList.length; i++) {
                  buffer.write("${checkedCategoryList[i].id}");
                  if (i != checkedCategoryList.length - 1) {
                    buffer.write(",");
                  }
                }
                Navigator.pop(context, {
                  "fromAmount": fromAmount.toString(),
                  "toAmount": toAmount.toString(),
                  "fromDate": fromDate.toString(),
                  "toDate": toDate.toString(),
                  "isDateFiltered": widget.isDateFiltered.toString(),
                  "selectedCategories": buffer.toString(),
                });
              },
              icon: const Icon(Icons.done),
              label: const Text("Apply"),
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _displayCatAlertDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 60 / 100,
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: categoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Row(
                        children: [
                          Image.asset(
                            categoryList[index].icon!,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(categoryList[index].title!),
                          )
                        ],
                      ),
                      value: categoryList[index].isChecked,
                      onChanged: (value) {
                        setState(() {
                          categoryList[index].isChecked = value!;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      setState(
                        () {
                          checkedCategoryList = categoryList
                              .where((element) => element.isChecked)
                              .toList();
                        },
                      );
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Okay"))
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _amountRangeDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('AMOUNT RANGE'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fromAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      labelText: "From"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: toAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      labelText: "To"),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  if (fromAmountController.text.isEmpty &&
                      toAmountController.text.isEmpty) {
                    return;
                  }
                  setState(() {
                    fromAmount = int.parse(fromAmountController.text);
                    toAmount = int.parse(toAmountController.text);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Future<String> _navigateToDatePicker(BuildContext context) async {
    String dateRange = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DateRangePicker("$fromDate~$toDate", widget.isDateFiltered),
        ));
    if (!mounted) return "";

    if (dateRange.isNotEmpty) {
      setState(() {
        widget.isDateFiltered = true;
        fromDate = DateFormat("yyyy-MM-dd").parse(dateRange.split("~")[0]);
        toDate = DateFormat("yyyy-MM-dd").parse(dateRange.split("~")[1]);
      });
    }
    return dateRange;
  }
}
