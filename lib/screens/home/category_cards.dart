import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../model/categories.dart';

class CategoryCards extends StatelessWidget {
  const CategoryCards({
    Key? key,
    required this.categories,
    required this.index,
  }) : super(key: key);

  final List<Categories> categories;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(Utils.getPreportionalWidth(context, 0.03))),
      child: Column(
        children: [
          SizedBox(
            height: Utils.getPreportionalWidth(context, 0.025),
          ),
          Image.asset(
            categories[index].icon!,
            width: Utils.getPreportionalWidth(context, 0.100),
          ),
          SizedBox(
            height: Utils.getPreportionalWidth(context, 0.080),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Utils.getPreportionalWidth(context, 0.012)),
            child: Container(
              height: 2,
              color: Color(
                  int.parse(categories[index].color!.replaceAll('#', '0xff'))),
            ),
          ),
          SizedBox(
            height: Utils.getPreportionalWidth(context, 0.030),
          ),
          Text(categories[index].title!)
        ],
      ),
    );
  }
}
