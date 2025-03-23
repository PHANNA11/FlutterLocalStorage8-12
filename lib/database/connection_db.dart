import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/note_model.dart';

class ConnectionDb {
  final String table = 'notetb';
  Future<Database> initDatabse() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'noteDB.db');
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE $table (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT)');
    });
  }

  Future<void> insertNote({required NoteModel note}) async {
    var db = await initDatabse();
    await db.insert(table, note.toMap());
    print('object was added');
  }

  Future<List<NoteModel>> getNotes() async {
    var db = await initDatabse();
    List<Map<String, dynamic>> result = await db.query(table);

    return result.map((e) => NoteModel.fronMap(map: e)).toList();
  }

  Future<void> deleteNote({required int id}) async {
    var db = await initDatabse();

    await db.delete(table, where: 'id=?', whereArgs: [id]);
  }

  Future<void> updateNote({required NoteModel note}) async {
    var db = await initDatabse();
    await db.update(table, note.toMap(), where: 'id=?', whereArgs: [note.id]);
  }
}
