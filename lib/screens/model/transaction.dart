class TransactionModel {
  int? id;
  String? title;
  String? description;
  double? amount;
  String? submitted;
  String? time;
  String? categoryId;
  String? type;
  String? currencySymbol;

  TransactionModel(
      {this.id,
      this.title,
      this.description,
      this.amount,
      this.submitted,
      this.time,
      this.categoryId,
      this.type,
      this.currencySymbol});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    amount = double.tryParse(json['amount'] ?? '0.0') ?? 0.0;
    submitted = json['submitted'];
    time = json['time'];
    categoryId = json['categoryId'];
    type = json['type'];
    currencySymbol = json['currencySymbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['amount'] = amount;
    data['submitted'] = submitted;
    data['time'] = time;
    data['categoryId'] = categoryId;
    data['type'] = type;
    data['currencySymbol'] = currencySymbol;
    return data;
  }
}
