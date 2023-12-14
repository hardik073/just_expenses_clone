import 'dart:io';
import 'package:just_expenses_clone/screens/model/categories.dart';
import 'package:just_expenses_clone/screens/model/transaction.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();
  static Database? _database;

  Future<Database> get getDB async {
    if (_database == null) {
      _database = await initDb();
      return _database!;
    } else {
      return _database!;
    }
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "just_expense.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Categories(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, color TEXT, icon TEXT, type TEXT)");
    await db.execute(
        "CREATE TABLE TransactionModel(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount TEXT, description TEXT, submitted TEXT, time TEXT, categoryId TEXT, type TEXT, currencySymbol TEXT)");
  }

  Future<int> saveCategories(Categories categories) async {
    var dbClient = await getDB;
    int res = await dbClient.insert("Categories", categories.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<int> saveTransaction(TransactionModel transaction) async {
    var dbClient = await getDB;
    int res = await dbClient.insert("TransactionModel", transaction.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    var dbClient = await getDB;
    int res = await dbClient.update("TransactionModel", transaction.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: 'id= ?',
        whereArgs: [transaction.id]);
    return res;
  }

  Future<List<Categories>> retriveCategories() async {
    var dbClient = await getDB;
    final List<Map<String, Object?>> queryResult =
        await dbClient.query("Categories");
    return queryResult.map((e) => Categories.fromJson(e)).toList();
  }

  Future<Categories> getCategoryById(String catId) async {
    var dbClient = await getDB;
    final List<Map<String, dynamic>> maps =
        await dbClient.query('Categories', where: 'id=?', whereArgs: [catId]);
    return Categories.fromJson(maps[0]);
  }

  Future<List<TransactionModel>> retriveTransactions() async {
    var dbClient = await getDB;
    final List<Map<String, Object?>> queryResult =
        await dbClient.query("TransactionModel");
    return queryResult.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<List<TransactionModel>> retriveTransactionsByCatId(catId) async {
    var dbClient = await getDB;
    final List<Map<String, Object?>> queryResult = await dbClient
        .query("TransactionModel", where: 'categoryId=?', whereArgs: [catId]);
    return queryResult.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<List<TransactionModel>> retriveTransactionsByDay(dateTime) async {
    String startOfDay =
        DateTime(dateTime.year, dateTime.month, dateTime.day).toString();
    var dbClient = await getDB;
    final List<Map<String, Object?>> queryResult = await dbClient.query(
        "TransactionModel",
        where: 'submitted=?',
        whereArgs: [startOfDay]);
    return queryResult.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future deleteTransaction(int? id) async {
    var dbClient = await getDB;
    dbClient.delete('TransactionModel', where: 'id=?', whereArgs: [id]);
  }

  Future<int> updateCategory(Categories category) async {
    var dbClient = await getDB;
    int res = await dbClient.update("Categories", category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: 'id= ?',
        whereArgs: [category.id]);
    return res;
  }

  Future<int> insertCategory(Categories category) async {
    var dbClient = await getDB;
    int res = await dbClient.insert("Categories", category.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future deleteCategory(int? id) async {
    var dbClient = await getDB;
    dbClient.delete('Categories', where: 'id=?', whereArgs: [id]);
    dbClient.delete('TransactionModel', where: 'categoryId=?', whereArgs: [id]);
  }

  Future<int> getLastCategoryId() async {
    var dbClient = await getDB;
    final List<Map<String, Object?>> maps =
        await dbClient.query("Categories ORDER BY ID DESC LIMIT 1");
    return Categories.fromJson(maps[0]).id!;
  }

  Future updateCurrencySymbol(String symbol) async {
    var dbClient = await getDB;
    int count = await dbClient
        .rawUpdate('UPDATE TransactionModel SET currencySymbol = ? ', [symbol]);
  }
}
