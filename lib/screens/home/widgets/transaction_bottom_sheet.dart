import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../../data/database_helper.dart';
import '../../../utils/utils.dart';
import '../../model/categories.dart';
import '../../model/transaction.dart';

class TransactionBottomSheet {
  static final TransactionBottomSheet _instance =
      TransactionBottomSheet.internal();
  TransactionBottomSheet.internal();
  factory TransactionBottomSheet() => _instance;

  static String selectedDate = "";
  static String selectedCategory = "";
  static String type = "";

  static TextEditingController dateController = TextEditingController();
  static TextEditingController timeController = TextEditingController();
  static TextEditingController titleController = TextEditingController();
  static TextEditingController amountController = TextEditingController();
  static TextEditingController descController = TextEditingController();

  static popUpBottomSheet(
      BuildContext context,
      int index,
      DatabaseHelper databaseHelper,
      String selectedCategory,
      bool isEdit,
      TransactionModel transaction,
      String categoryId,
      String type,
      VoidCallback getTransactionsCallback,
      List<Categories> categories) async {
    String catId = categoryId;

    VoidCallback getTransactions = getTransactionsCallback;
    if (isEdit) {
      dateController.text = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(transaction.submitted!));
      selectedDate = transaction.submitted!;
      timeController.text = transaction.time!;
      titleController.text = transaction.title!;
      amountController.text = transaction.amount.toString();
      descController.text = transaction.description!;
      catId = transaction.categoryId!;
      selectedCategory = selectedCategory;
      type = type;
    } else {
      dateController.text = "";
      selectedDate = "";
      timeController.text = "";
      titleController.text = "";
      amountController.text = "";
      descController.text = "";
    }

    Categories catModel = await databaseHelper.getCategoryById(catId);

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                        Utils.getPreportionalWidth(context, 0.030)),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  Utils.getPreportionalWidth(context, 0.010)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: kPrimaryColor, width: 1),
                          ),
                          child: TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                                hintText: "Title", border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                            height: Utils.getPreportionalWidth(context, 0.040)),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  Utils.getPreportionalWidth(context, 0.010)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: kPrimaryColor, width: 1),
                          ),
                          child: TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "Amount", border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                            height: Utils.getPreportionalWidth(context, 0.040)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: kPrimaryColor, width: 1),
                          ),
                          child: TextField(
                            controller: descController,
                            decoration: const InputDecoration(
                                hintText: "Description",
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                            height: Utils.getPreportionalWidth(context, 0.040)),
                        Container(
                          height: Utils.getPreportionalWidth(context, 0.10),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: kPrimaryColor, width: 1),
                          ),
                          child: TextField(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                selectedDate = pickedDate.toLocal().toString();

                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);

                                setState(() {
                                  dateController.text = formattedDate;
                                });
                              }
                            },
                            controller: dateController,
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "Select Date",
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                            height: Utils.getPreportionalWidth(context, 0.040)),
                        Container(
                          height: Utils.getPreportionalWidth(context, 0.10),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: kPrimaryColor, width: 1),
                          ),
                          child: TextField(
                            onTap: () async {
                              final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                initialEntryMode: TimePickerEntryMode.dial,
                              );
                              if (timeOfDay != null) {
                                DateTime parsedTime = DateFormat.jm().parse(
                                    timeOfDay.format(context).toString());
                                String formattedTime =
                                    DateFormat('hh:mm a').format(parsedTime);
                                setState(() {
                                  timeController.text = formattedTime;
                                });
                              }
                            },
                            controller: timeController,
                            readOnly: true,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "Select Time",
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: Utils.getPreportionalWidth(context, 0.50),
                      height: Utils.getPreportionalWidth(context, 0.10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(int.parse(
                              catModel.color!.replaceAll('#', '0xff'))),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            catModel.icon!,
                            width: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            catModel.title!,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Utils.getPreportionalWidth(context, 0.010)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                              Utils.getPreportionalWidth(context, 0.50),
                              Utils.getProportionalHeight(context, 0.05)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () {
                        String _categoryID = categories
                            .where(
                                (element) => element.title == selectedCategory)
                            .first
                            .id!
                            .toString();

                        TransactionModel _transaction = TransactionModel(
                            id: transaction.id,
                            title: titleController.text,
                            description: descController.text,
                            amount: double.parse(amountController.text),
                            submitted: selectedDate,
                            time: timeController.text,
                            categoryId: _categoryID,
                            type: type);

                        if (isEdit) {
                          updateTransaction(_transaction, databaseHelper);
                          getTransactions();
                        } else {
                          addTransaction(_transaction, databaseHelper);
                        }

                        Navigator.pop(context);
                      },
                      child: Text(
                          isEdit ? "Update Transaction" : "Add Transaction",
                          style: const TextStyle(fontSize: 18))),
                  SizedBox(height: Utils.getPreportionalWidth(context, 0.100)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static Future<void> addTransaction(
      TransactionModel transaction, DatabaseHelper databaseHelper) async {
    var insert = await databaseHelper.saveTransaction(transaction);
  }

  static Future<void> updateTransaction(
      TransactionModel transaction, DatabaseHelper databaseHelper) async {
    var insert = await databaseHelper.updateTransaction(transaction);
  }
}
