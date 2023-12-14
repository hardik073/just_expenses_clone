class Categories {
  int? id;
  String? title;
  String? color;
  String? icon;
  String? type;

  Categories({this.id, this.title, this.color, this.icon, this.type});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    color = json['color'];
    icon = json['icon'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['color'] = color;
    data['icon'] = icon;
    data['type'] = type;
    return data;
  }
}
