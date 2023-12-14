import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_expenses_clone/utils/utils.dart';

import '../../constants.dart';
import '../../data/database_helper.dart';
import '../home/widgets/transaction_bottom_sheet.dart';
import '../model/categories.dart';
import '../model/transaction.dart';

class ListingTransactionList extends StatefulWidget {
  final AsyncSnapshot<Categories> snapshot;
  final int index;
  final List<TransactionModel> transactionList;
  final DatabaseHelper _databaseHelper;
  final VoidCallback getTransactions;
  const ListingTransactionList(this.snapshot, this.index, this.transactionList,
      this._databaseHelper, this.getTransactions,
      {super.key});

  @override
  State<ListingTransactionList> createState() => _ListingTransactionListState();
}

class _ListingTransactionListState extends State<ListingTransactionList> {
  final DateFormat dateFormat = DateFormat.yMMMEd('en_US');
  List<Categories> categoriesList = [];
  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() async {
    categoriesList = await widget._databaseHelper.retriveCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2.0)],
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          )),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15.0),
                ),
              ),
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: Utils.getPreportionalWidth(context, 0.08),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(int.parse(widget
                                      .snapshot.data!.color!
                                      .replaceAll('#', '0xff'))),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      widget.snapshot.data!.icon!,
                                      width: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      widget.snapshot.data!.title!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Text((widget.transactionList[widget.index]
                                        .currencySymbol ??
                                    "") +
                                widget.transactionList[widget.index].amount
                                    .toString()),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 0.5,
                        color: kPrimaryColor,
                      ),
                      InkWell(
                        onTap: () {
                          TransactionBottomSheet.popUpBottomSheet(
                              context,
                              widget.index,
                              widget._databaseHelper,
                              widget.snapshot.data!.title!,
                              true,
                              widget.transactionList[widget.index],
                              "",
                              widget.snapshot.data!.type!,
                              widget.getTransactions,
                              categoriesList);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.edit,
                                color: kPrimaryColor,
                              ),
                              SizedBox(width: 10),
                              Text("Update")
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      InkWell(
                        onTap: () {
                          widget._databaseHelper.deleteTransaction(
                              widget.transactionList[widget.index].id);
                          widget.getTransactions();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: const [
                              Icon(Icons.delete_outline_outlined,
                                  color: kPrimaryColor),
                              SizedBox(width: 10),
                              Text("Remove")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(int.parse(widget.snapshot.data!.color!
                          .replaceAll('#', '0xff'))),
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        widget.snapshot.data!.icon!,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.snapshot.data!.title!,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Text(
                  (widget.transactionList[widget.index].currencySymbol ?? "") +
                      widget.transactionList[widget.index].amount.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.transactionList[widget.index].title!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.transactionList[widget.index].description!,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(dateFormat.format(DateFormat("yyyy-MM-dd h:mm:ss")
                    .parse(widget.transactionList[widget.index].submitted!))),
                const SizedBox(
                  width: 10,
                ),
                Text(widget.transactionList[widget.index].time.toString())
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
