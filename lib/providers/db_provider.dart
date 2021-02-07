import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  static Database _database;

  static final DbProvider db = DbProvider._();

  DbProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    final path = join(Directory.current.path, "buttons.db");
    debugPrint(path);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(''' 
          CREATE TABLE ACTions(
            id iNTEGER PRIMARY KEY,
            texto TEXT,
            isToggle INTEGER
          )
        ''');
    });
  }
}
