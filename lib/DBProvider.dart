import 'dart:io';
import 'package:path_provider/path_provider.dart';
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
    await _database.execute("");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await _database.execute("");
  }

  void addItem() {

  }

  void removeItem() {

  }

  void updateItem() {

  }
}