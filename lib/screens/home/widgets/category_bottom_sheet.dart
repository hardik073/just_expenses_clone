import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../constants.dart';
import '../../../data/database_helper.dart';
import '../../../utils/icons_list.dart';
import '../../../utils/utils.dart';
import '../../model/categories.dart';

class CategoryBottomSheet {
  static showCategoryBottomSheet(
      context,
      Categories category,
      DatabaseHelper databaseHelper,
      VoidCallback refreshPage,
      bool isEdit,
      int lastCatId) {
    String hexColorCode = '#d9508a';
    String name = 'Untitled';
    String icon = 'assets/icons/analysis.png';
    int catId = 0;
    String type = 'exp';

    if (isEdit) {
      hexColorCode = category.color!;
      name = category.title!;
      icon = category.icon!;
      catId = category.id!;
      type = category.type!;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Category",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const Spacer(),
                    Visibility(
                      visible: isEdit ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: IconButton(
                          onPressed: () {
                            databaseHelper.deleteCategory(catId);
                            Navigator.pop(context);
                            refreshPage();
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Name",
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              final titleController = TextEditingController();
                              if (name.isNotEmpty) {
                                titleController.text = name;
                                titleController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: titleController.text.length));
                              }

                              return AlertDialog(
                                content: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Utils.getPreportionalWidth(
                                          context, 0.010)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: kPrimaryColor, width: 0.5),
                                  ),
                                  child: TextFormField(
                                    controller: titleController,
                                    decoration: const InputDecoration(
                                        hintText: "Name",
                                        border: InputBorder.none),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        name = titleController.text;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Ok"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(name.isEmpty ? "Untitled" : name),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Color",
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: hexColorCode.isNotEmpty
                                    ? Color(int.parse(
                                        hexColorCode.replaceAll('#', '0xff')))
                                    : kPrimaryColor,
                                onColorChanged: (color) {
                                  hexColorCode =
                                      '#${color.value.toRadixString(16).substring(2, 8)}';
                                },
                                colorPickerWidth:
                                    Utils.getProportionalHeight(context, 0.30),
                                pickerAreaHeightPercent: 0.7,
                                displayThumbColor: true,
                                paletteType: PaletteType.hsv,
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hexColorCode.isNotEmpty
                                ? Color(int.parse(
                                    hexColorCode.replaceAll('#', '0xff')))
                                : kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Icon",
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            child: SizedBox(
                              height:
                                  Utils.getProportionalHeight(context, 0.40),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(30),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          icon = iconsFromList[index];
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Image.asset(
                                        iconsFromList[index],
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  );
                                },
                                itemCount: iconsFromList.length,
                              ),
                            ),
                          );
                        },
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hexColorCode.isNotEmpty
                                ? Color(
                                    int.parse(
                                        hexColorCode.replaceAll('#', '0xff')),
                                  )
                                : kPrimaryColor,
                          ),
                          child: Image.asset(
                            icon.isNotEmpty ? icon : iconsFromList[0],
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                FloatingActionButton(
                  onPressed: () {
                    lastCatId = lastCatId + 1;
                    Categories cat = Categories(
                        id: catId == 0 ? lastCatId : catId,
                        title: name,
                        color: hexColorCode,
                        icon: icon,
                        type: type);
                    if (isEdit) {
                      var update = databaseHelper.updateCategory(cat);
                    } else {
                      var insert = databaseHelper.insertCategory(cat);
                    }
                    Navigator.of(context).pop();
                    refreshPage();
                  },
                  child: Icon(isEdit ? Icons.edit : Icons.done),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            );
          },
        );
      },
    );
  }
}
