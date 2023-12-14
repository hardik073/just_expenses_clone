import 'package:flutter/material.dart';

class Utils {
  static Map<String, dynamic> getMapFromJsonString(String jsonString) {
    List<String> str =
        jsonString.replaceAll("{", "").replaceAll("}", "").split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }

    return result;
  }

  static getPreportionalWidth(context,percent) {
    double width = MediaQuery.of(context).size.width;
    return width * percent;
  }

  static getProportionalHeight(context,percent) {
    double height = MediaQuery.of(context).size.height;
    return height * percent;
  }
}
