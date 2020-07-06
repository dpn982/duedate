import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:duedate/models/PaymentModel.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DBProvider {
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<void> open() async {
    await Hive.initFlutter();
  }
}