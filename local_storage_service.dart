// lib/services/local_storage_service.dart
import 'package:hive/hive.dart';
import 'course_model.dart';
import 'course_adapter.dart';

class LocalStorageService {
  static const String _boxName = 'courses';

  static Future<Box<Course>> openBox() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CourseAdapter());
    }
    return await Hive.openBox<Course>(_boxName);
  }

  static Future<void> addCourse(Course course) async {
    final box = await openBox();
    await box.add(course);
  }

  static Future<List<Course>> getCourses() async {
    final box = await openBox();
    return box.values.toList();
  }

  static Future<void> deleteCourse(int index) async {
    final box = await openBox();
    await box.deleteAt(index);
  }
}