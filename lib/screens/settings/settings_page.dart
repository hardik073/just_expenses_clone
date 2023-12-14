import 'package:flutter/material.dart';
import 'package:just_expenses_clone/constants.dart';
import 'package:just_expenses_clone/data/database_helper.dart';

import '../../utils/utils.dart';
import 'category_customize.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool light0 = true;
  final databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2.0)],
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Utils.getProportionalHeight(context, 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: primarySwatch,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Reminder"),
                  Spacer(),
                  Switch(
                    value: light0,
                    onChanged: (bool value) {
                      setState(() {
                        light0 = value;
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 0.5,
              color: primarySwatch,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryCustomizePage(),
                  )),
              child: Container(
                height: Utils.getProportionalHeight(context, 0.05),
                child: Row(
                  children: const [
                    Icon(
                      Icons.edit_note_rounded,
                      color: primarySwatch,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Customize categories")
                  ],
                ),
              ),
            ),
            Container(
              height: 0.5,
              color: primarySwatch,
            ),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CurrencySymbol("\$", databaseHelper),
                                CurrencySymbol("¥", databaseHelper),
                                CurrencySymbol("£", databaseHelper)
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CurrencySymbol("₹", databaseHelper),
                                CurrencySymbol("€", databaseHelper),
                                CurrencySymbol("₽", databaseHelper)
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              child: Container(
                height: Utils.getProportionalHeight(context, 0.05),
                child: Row(
                  children: const [
                    Icon(
                      Icons.pin_outlined,
                      color: primarySwatch,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Choose Currency Symbol")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CurrencySymbol extends StatelessWidget {
  String symbol;
  DatabaseHelper databaseHelper;
  CurrencySymbol(
    this.symbol,
    this.databaseHelper, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        databaseHelper.updateCurrencySymbol(symbol);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        height: Utils.getProportionalHeight(context, 0.04),
        width: Utils.getProportionalHeight(context, 0.04),
        decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          symbol,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
