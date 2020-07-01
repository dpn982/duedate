import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:duedate/PaymentModel.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}/database.db";
    return await openDatabase(path, version: 1, onOpen: _onOpen,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade
    );
  }

  void _onOpen(Database db) async {

  }

  void _onCreate(Database db, int version) async {
    await _database.execute("CREATE TABLE Payment ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT NOT NULL,"
        "description TEXT,"
        "amount REAL,"
        "created_date TEXT,"
        "due_date TEXT,"
        "recurring BIT,"
        "frequency INTEGER,"
        "units TEXT,"
        "color TEXT,"
        "payment_method TEXT,"
        "interest_percentage REAL,"
        "compounded_frequency TEXT,"
        "notes TEXT,"
        "enabled BIT,"
        "hidden BIT"
        " )");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await _database.execute("");
  }

  newPayment(Payment newPayment) async {
    final db = await database;
    var res = await db.insert("Payment", newPayment.toMap());
    return res;
  }

  getPayment(int id) async {
    final db = await database;
    var res = await db.query("Payment", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Payment.fromMap(res.first) : Null ;
  }
}