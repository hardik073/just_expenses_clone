import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:just_expenses_clone/constants.dart';
import 'package:just_expenses_clone/screens/home/widgets/transaction_bottom_sheet.dart';
import 'package:just_expenses_clone/screens/model/transaction.dart';
import 'package:just_expenses_clone/utils/utils.dart';
import '../../data/database_helper.dart';
import '../../utils/categories_list.dart';
import '../../utils/icons_list.dart';
import '../model/categories.dart';
import 'category_cards.dart';
import 'widgets/category_bottom_sheet.dart';

class CategoryItem extends StatefulWidget {
  bool isCustomize;

  CategoryItem(this.isCustomize, {super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  late String selectedCategory = "";
  late String selectedDate = "";
  final _databaseHelper = DatabaseHelper();
  bool loading = true;

  @override
  void initState() {
    addCategories().then((value) {
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  refreshPage() {
    setState(() {});
  }

  Future<void> addCategories() async {
    List<Categories> list = await _databaseHelper.retriveCategories();
    if (list.isEmpty) {
      for (var cat in categoriesFromList) {
        await _databaseHelper.saveCategories(cat);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return FutureBuilder<List<Categories>>(
        initialData: const [],
        future: _databaseHelper.retriveCategories(),
        builder: (context, AsyncSnapshot<List<Categories>> snapshot) {
          List<Categories> categories = snapshot.data!;
          return snapshot.hasData
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        selectedCategory = categories[index].title!;

                        if (widget.isCustomize) {
                          await CategoryBottomSheet.showCategoryBottomSheet(
                              context,
                              categories[index],
                              _databaseHelper,
                              refreshPage,
                              true,
                              0);
                        } else {
                          TransactionBottomSheet.popUpBottomSheet(
                              context,
                              index,
                              _databaseHelper,
                              selectedCategory,
                              false,
                              TransactionModel(),
                              categories[index].id.toString(),
                              categories[index].type!,
                              () {},
                              categories);
                        }
                      },
                      child:
                          CategoryCards(categories: categories, index: index),
                    );
                  },
                  itemCount: categories.length,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      );
    }
  }
}

// showCategoryBottomSheet(
//     context, Categories category, DatabaseHelper databaseHelper) {
//   String hexColorCode = category.color!;
//   String name = category.title!;
//   String icon = category.icon!;
//   int catId = category.id!;
//   Color currentColor = const Color(0xFF4076A2);

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
//     ),
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: Text(
//                       "Category",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//                   const Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: IconButton(
//                       onPressed: () {},
//                       icon: const Icon(
//                         Icons.delete,
//                         color: kPrimaryColor,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: Text(
//                       "Name",
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () => showDialog(
//                       context: context,
//                       builder: (context) {
//                         return StatefulBuilder(
//                           builder: (context, setState) {
//                             final titleController =
//                                 TextEditingController(text: name);
//                             titleController.text = name;
//                             titleController.selection =
//                                 TextSelection.fromPosition(TextPosition(
//                                     offset: titleController.text.length));

//                             return AlertDialog(
//                               content: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: Utils.getPreportionalWidth(
//                                         context, 0.010)),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   border: Border.all(
//                                       color: kPrimaryColor, width: 0.5),
//                                 ),
//                                 child: TextFormField(
//                                   controller: titleController,
//                                   decoration: const InputDecoration(
//                                       hintText: "Name",
//                                       border: InputBorder.none),
//                                 ),
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context),
//                                   child: const Text("Cancel"),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       name = titleController.text;
//                                     });
//                                     Navigator.pop(context);
//                                   },
//                                   child: const Text("Ok"),
//                                 )
//                               ],
//                             );
//                           },
//                         );
//                       },
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Text(name),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: Text(
//                       "Color",
//                     ),
//                   ),
//                   const Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: GestureDetector(
//                       onTap: () => showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text('Pick a color!'),
//                           content: SingleChildScrollView(
//                             child: ColorPicker(
//                               pickerColor: currentColor,
//                               onColorChanged: (color) {
//                                 hexColorCode =
//                                     '#${color.value.toRadixString(16).substring(2, 8)}';
//                               },
//                               colorPickerWidth:
//                                   Utils.getProportionalHeight(context, 0.30),
//                               pickerAreaHeightPercent: 0.7,
//                               displayThumbColor: true,
//                               paletteType: PaletteType.hsv,
//                             ),
//                           ),
//                           actions: <Widget>[
//                             ElevatedButton(
//                               child: const Text('Got it'),
//                               onPressed: () {
//                                 setState(() {});
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       child: Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(
//                             hexColorCode != null
//                                 ? int.parse(
//                                     hexColorCode.replaceAll('#', '0xff'))
//                                 : int.parse(
//                                     category.color!.replaceAll('#', '0xff')),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: Text(
//                       "Icon",
//                     ),
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () => showDialog(
//                       context: context,
//                       builder: (context) {
//                         return Dialog(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.0)),
//                           child: SizedBox(
//                             height: Utils.getProportionalHeight(context, 0.40),
//                             child: GridView.builder(
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 4),
//                               itemBuilder: (context, index) {
//                                 return Container(
//                                   padding: const EdgeInsets.all(30),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         icon = iconsFromList[index];
//                                         Navigator.pop(context);
//                                       });
//                                     },
//                                     child: Image.asset(
//                                       iconsFromList[index],
//                                       color: kPrimaryColor,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               itemCount: iconsFromList.length,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Container(
//                         padding: const EdgeInsets.all(10),
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(
//                             int.parse(hexColorCode.replaceAll('#', '0xff')),
//                           ),
//                         ),
//                         child: Image.asset(
//                           icon,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               FloatingActionButton(
//                 onPressed: () {
//                   Categories cat = Categories(
//                       id: catId,
//                       title: name,
//                       color: hexColorCode,
//                       icon: icon,
//                       type: "exp");
//                   var insert = databaseHelper.updateCategory(cat);
//                   Navigator.of(context).pop();
//                 },
//                 child: const Icon(Icons.edit),
//               ),
//               const SizedBox(
//                 height: 20,
//               )
//             ],
//           );
//         },
//       );
//     },
//   );
// }
