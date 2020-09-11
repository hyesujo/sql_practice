import 'package:path/path.dart';
import 'package:sq2_flutter/data/memo.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = 'memohabbit';

class SqlDB {
  var _db;

  Future<Database> get datebase async {
    if (_db != null) return _db;
    _db = openDatabase(join(await getDatabasesPath(), 'memohabbit.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE memohabbit(id TEXT PRIMARY KEY, title TEXT, text TEXT, createTime TEXT,editTime TEXT)');
    }, version: 1);
    return _db;
  }

  Future<void> insertMeme(Memo memo) async {
    final db = await datebase;
    await db.insert(
      tableName,
      memo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Memo>> memos() async {
    final db = await datebase;
    final List<Map<String, dynamic>> maps = await db.query('memohabbit');
    return List.generate(maps.length, (i) {
      return Memo(
          id: maps[i]['id'],
          title: maps[i]['title'],
          text: maps[i]['text'],
          createTime: maps[i]['createTime'],
          editTime: maps[i]['editTime']);
    });
  }

  Future<void> updateMemo(Memo memo) async {
    final db = await this.datebase;

    await db.update(
      tableName,
      memo.toMap(),
      where: 'id = ?',
      whereArgs: [memo.id],
    );
  }

  Future<void> deleteMemo(String id) async {
    final db = await this.datebase;

    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Memo>> findMemo(String id) async {
    final sdb = await this.datebase;
    final List<Map<String, dynamic>> maps =
        await sdb.query('memohabbit', where: 'id = ?', whereArgs: [id]);
    return List.generate(maps.length, (i) {
      return Memo(
          id: maps[i]['id'],
          title: maps[i]['title'],
          text: maps[i]['text'],
          createTime: maps[i]['createTime'],
          editTime: maps[i]['editTime']);
    });
  }
}
