import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const String dbName = 'students.db';
  static const String tableName = 'students';
  static const int dbVersion = 1;

  // Initialize database
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )''',
        );
      },
    );
  }

  // Add a new student
  static Future<int> addStudent(String name) async {
    final db = await _initDatabase();
    return db.insert(
      tableName,
      {
        'name': name,
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
  }

  // Get all students
  static Future<List<Map<String, dynamic>>> getAllStudents() async {
    final db = await _initDatabase();
    return db.query(tableName, orderBy: 'id DESC');
  }

  // Delete a student
  static Future<int> deleteStudent(int id) async {
    final db = await _initDatabase();
    return db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}