import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:just_expenses_clone/screens/filter_transactions/filter_screen.dart';
import 'package:just_expenses_clone/screens/listing/transaction_listing.dart';
import 'package:just_expenses_clone/screens/model/transaction.dart';

import '../../constants.dart';
import '../../data/database_helper.dart';
import '../../utils/utils.dart';
import '../model/categories.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  TextEditingController searchEditingController = TextEditingController();

  late Categories catModel;
  final _databaseHelper = DatabaseHelper();
  List<TransactionModel> transactionList = [];
  List<TransactionModel> transListFromDB = [];
  List<String> catIdList = [];
  List<Categories> categoryList = [];
  List<Categories> tempCategoryList = [];
  late String amountRange, dateRange;
  bool hasFromAmount = false,
      hasToAmount = false,
      isDateFiltered = false,
      isCatFiltered = false;
  int fromAmount = 0, toAmount = 0;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  @override
  void initState() {
    initializeDateFormatting();
    getTransactions();
    super.initState();
  }

  getTransactions() async {
    categoryList.clear();
    categoryList = await _databaseHelper.retriveCategories();
    transactionList.clear();
    transactionList = await _databaseHelper.retriveTransactions();
    transListFromDB = transactionList;
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<TransactionModel> dummySearchList = [];
    dummySearchList.addAll(transactionList);
    if (query.isNotEmpty) {
      List<TransactionModel> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.title!.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        transactionList.clear();
        transactionList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        transactionList.clear();
        transactionList.addAll(getTransactions());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(Utils.getProportionalHeight(context, 0.065)),
            child: Container(
              color: kPrimaryColor,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: Utils.getPreportionalWidth(context, 0.02)),
                    child: Container(
                      height: Utils.getProportionalHeight(context, 0.04),
                      width: Utils.getPreportionalWidth(context, 0.85),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.search,
                              color: kPrimaryColor,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                filterSearchResults(value);
                              },
                              controller: searchEditingController,
                              decoration: const InputDecoration(
                                  hintText: "Search", border: InputBorder.none),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _navigateToFilterScreen(context),
                    child: SizedBox(
                      height: Utils.getProportionalHeight(context, 0.10),
                      width: Utils.getPreportionalWidth(context, 0.12),
                      child: const Icon(
                        Icons.line_axis,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible:
                  hasFromAmount || hasToAmount || isDateFiltered ? true : false,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 10),
                color: kPrimaryColor,
                child: Row(
                  children: [
                    SizedBox(
                      width: Utils.getPreportionalWidth(context, 0.02),
                    ),
                    Visibility(
                      visible: hasFromAmount ? true : false,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        decoration: const BoxDecoration(
                            color: Colors.white,
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
                                  hasFromAmount = false;
                                  filterListing();
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
                      width: 15,
                    ),
                    Visibility(
                      visible: hasToAmount ? true : false,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        decoration: const BoxDecoration(
                            color: Colors.white,
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
                                  hasToAmount = false;
                                  filterListing();
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
                      width: 15,
                    ),
                    Visibility(
                      visible: isDateFiltered ? true : false,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                        decoration: const BoxDecoration(
                            color: Colors.white,
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
                                  isDateFiltered = false;
                                  filterListing();
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
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isCatFiltered ? true : false,
              child: Container(
                width: double.infinity,
                height: 55,
                color: kPrimaryColor,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: tempCategoryList.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      children: [
                        Text(tempCategoryList[index].title!),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              filterCategoryWise(
                                  tempCategoryList[index].id, true);
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
              ),
            ),
            transactionList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return FutureBuilder<Categories>(
                          future: _databaseHelper.getCategoryById(
                              transactionList[index].categoryId!),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? ListingTransactionList(
                                    snapshot,
                                    index,
                                    transactionList,
                                    _databaseHelper,
                                    getTransactions)
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                        );
                      },
                      itemCount: transactionList.length,
                    ),
                  )
                : const Center(
                    child: Text(
                      "No data available for search",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  _navigateToFilterScreen(BuildContext context) async {
    var buffer = StringBuffer();

    for (int i = 0; i < catIdList.length; i++) {
      buffer.write(catIdList[i]);
      if (i != catIdList.length - 1) {
        buffer.write(",");
      }
    }

    Map<String, String> result =
        await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return FilterScreen(
            fromAmount.toString(),
            toAmount.toString(),
            fromDate.toString(),
            toDate.toString(),
            isDateFiltered,
            buffer.toString());
      },
    ));

    if (!mounted) return "";

    hasFromAmount = false;
    hasToAmount = false;

    if (result["fromAmount"] != null && result["fromAmount"] != "0") {
      hasFromAmount = true;
      fromAmount = int.parse(result["fromAmount"]!);
    }
    if (result["toAmount"] != null && result["toAmount"] != "0") {
      hasToAmount = true;
      toAmount = int.parse(result["toAmount"]!);
    }

    if (result["isDateFiltered"] != null &&
        result["isDateFiltered"] == "true") {
      isDateFiltered = true;
      fromDate = DateFormat("yyyy-MM-dd").parse(result["fromDate"]!);
      toDate = DateFormat("yyyy-MM-dd").parse(result["toDate"]!);
    }

    if (result["selectedCategories"] != null) {
      isCatFiltered = true;
      catIdList.clear();
      for (var element in result["selectedCategories"]!.split(",")) {
        catIdList.add(element);
      }
    }

    filterListing();
  }

  filterListing() {
    setState(
      () {
        transactionList = transListFromDB
            .where((element) =>
                element.amount! >= fromAmount &&
                (toAmount != 0 ? element.amount! <= toAmount : true))
            .toList()
            .where(
          (element) {
            DateTime submittedDate =
                DateFormat("yyyy-MM-dd").parse(element.submitted!);
            return isDateFiltered
                ? (submittedDate.isAtSameMomentAs(fromDate) ||
                        submittedDate.isAtSameMomentAs(toDate)) ||
                    submittedDate.isAfter(fromDate) &&
                        submittedDate.isBefore(toDate)
                : true;
          },
        ).toList();

        filterCategoryWise(0, false);

        clearFilter();
      },
    );
  }

  clearFilter() {
    if (!hasFromAmount && !hasToAmount && !isDateFiltered && !isCatFiltered) {
      getTransactions();
    }
  }

  filterCategoryWise(int? id, bool isRemove) {
    if (isRemove) {
      catIdList.remove(id.toString());
      tempCategoryList.removeWhere((element) => element.id == id);
    }

    if (catIdList.isNotEmpty) {
      List<TransactionModel> tempList = [];
      for (var i = 0; i < transactionList.length; i++) {
        TransactionModel model = transactionList[i];
        for (var element in catIdList) {
          if (model.categoryId == element) {
            tempList.add(model);
          }
        }
      }
      transactionList = tempList;
    }

    tempCategoryList.clear();
    for (var element in categoryList) {
      for (var element1 in catIdList) {
        if (element1 == element.id.toString()) {
          tempCategoryList.add(element);
        }
      }
    }
    if (tempCategoryList.isEmpty) isCatFiltered = false;

    clearFilter();
  }
}
