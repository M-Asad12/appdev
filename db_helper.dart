import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const String dbName = 'marks.db';
  static const String tableName = 'marks';

  // Initialize the database
  static Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Create the marks table with student name
        return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, studentName TEXT, subject TEXT, marks REAL)',
        );
      },
    );
  }

  // Insert marks along with student name into the database
  static Future<void> insertMarks(String studentName, String subject, double marks) async {
    final db = await _initializeDatabase();
    await db.insert(
      tableName,
      {'studentName': studentName, 'subject': subject, 'marks': marks},
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
    );
  }

  // Retrieve all marks and student names from the database
  static Future<List<Map<String, dynamic>>> getMarks() async {
    final db = await _initializeDatabase();
    return await db.query(tableName);
  }

  // Delete all records from the marks table
  static Future<void> deleteAllMarks() async {
    final db = await _initializeDatabase();
    await db.delete(tableName);
  }
}
