import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DatabaseHelper {
  static Database? _database;
  static const String DB_NAME = 'tasks.db';
  static const String TABLE = 'tasks';
  static const String COL_ID = 'id';
  static const String COL_NAME = 'name';
  static const String COL_IS_DONE = 'isDone';

  // Creates a database if not exists
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // Initializes the database
  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $TABLE (
          $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $COL_NAME TEXT,
          $COL_IS_DONE INTEGER
        )
      ''');
    });
  }

  // Inserts a task into the database
  Future<int> insertTask(Task task) async {
    Database db = await database;
    return await db.insert(TABLE, task.toMap());
  }

  // Gets all tasks from the database
  Future<List<Task>> getTasks() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(TABLE);
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Updates task in the database
  Future<int> updateTask(Task task) async {
    Database db = await database;
    return await db.update(
      TABLE,
      task.toMap(),
      where: '$COL_ID = ?',
      whereArgs: [task.id],
    );
  }

  // Deletes task from the database
  Future<int> deleteTask(int id) async {
    Database db = await database;
    return await db.delete(
      TABLE,
      where: '$COL_ID = ?',
      whereArgs: [id],
    );
  }

  // Closes the database
  Future<void> closeDatabase() async {
    Database db = await database;
    db.close();
  }
}
