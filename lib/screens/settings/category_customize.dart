import 'package:flutter/material.dart';
import 'package:just_expenses_clone/screens/home/widgets/category_bottom_sheet.dart';
import 'package:just_expenses_clone/screens/model/categories.dart';

import '../../data/database_helper.dart';
import '../home/category_item.dart';

class CategoryCustomizePage extends StatefulWidget {
  @override
  CategoryCustomizePageState createState() => CategoryCustomizePageState();
}

class CategoryCustomizePageState extends State<CategoryCustomizePage> {
  final databaseHelper = DatabaseHelper();
  int lastCatId = 0;
  @override
  void initState() {
    getLastCatId();
    super.initState();
  }

  getLastCatId() async {
    lastCatId = await databaseHelper.getLastCategoryId();
  }

  refreshPage() {
    getLastCatId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize Category"),
      ),
      body: CategoryItem(true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => CategoryBottomSheet.showCategoryBottomSheet(context,
            Categories(), databaseHelper, refreshPage, false, lastCatId),
        child: const Icon(Icons.add),
      ),
    );
  }
}
