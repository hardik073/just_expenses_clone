import 'package:flutter/material.dart';
import 'package:just_expenses_clone/constants.dart';
import 'package:just_expenses_clone/screens/home/category_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroudColor,
      appBar: AppBar(
        title: const Text("Just Expenses"),
        centerTitle: true,
      ),
      body: CategoryItem(false),
    );
  }
}
