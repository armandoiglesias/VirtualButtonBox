import 'package:sqflite/sqflite.dart';
import 'package:virtual_button_box/model/actionButton.dart';
import 'package:path/path.dart';

class DbProvider {
  static Database _database;
  final String _dbName = "button.db";

  static final DbProvider db = DbProvider._();

  DbProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await openDB(this._dbName);

    return _database;
  }

  Future<Database> openDB(String path) async {
    String _path = join(await getDatabasesPath(), path);

    return await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(''' 
          CREATE TABLE Actions3(
            id iNTEGER PRIMARY KEY,
            texto TEXT,
            isToggle INTEGER,
            filePath TEXT,
            indice INTEGER
          )
        ''');
    });
  }

  Future<List<ActionButtonModel>> getButtons() async {
    List<Map<String, dynamic>> _list = await _database.query("Actions3");
    return _list.map((x) {
      return ActionButtonModel.fromMap(x);
    });
  }

  Future<ActionButtonModel> getButton(int index) async {
    final _db = await database;
    final maps =
        await _db.query("Actions3", where: "indice = ?", whereArgs: [index]);
    if (maps.length > 0) {
      return ActionButtonModel.fromMap(maps.first);
    }
    return null;
  }

  Future close() async => db.close();

  Future<ActionButtonModel> insert(ActionButtonModel todo) async {
    final _db = await database;
    todo.id = await _db.insert("Actions3", todo.toMap());
    return todo;
  }

  Future<int> update(ActionButtonModel todo) async {
    final _db = await database;
    return await _db.update("Actions3", todo.toMap(),
        where: 'indice = ?', whereArgs: [todo.indice]);
  }
}
