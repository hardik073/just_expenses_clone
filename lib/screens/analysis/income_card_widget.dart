import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class IncomeCardWidget extends StatelessWidget {
  int income;
  double averageIncomeAmount;
  String averageText;
  String currencySymbol;
  IncomeCardWidget(
    this.income,
    this.averageIncomeAmount,
    this.averageText,
    this.currencySymbol, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.green[400]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(15, 20, 0, 0),
              child: const Text(
                "Total",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 12, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    income.toString(),
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 1,
              color: Colors.white,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 12, 10, 0),
              child: Text(
                averageText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 12, 10, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    currencySymbol + averageIncomeAmount.toStringAsFixed(2),
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
