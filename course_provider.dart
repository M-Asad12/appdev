// lib/providers/course_provider.dart
import 'package:flutter/foundation.dart';
import 'course_model.dart';
import 'local_storage_service.dart';
import 'api_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _localCourses = [];
  List<Course> _apiCourses = [];
  bool _isLoading = false;

  List<Course> get localCourses => _localCourses;
  List<Course> get apiCourses => _apiCourses;
  bool get isLoading => _isLoading;

  Future<void> loadLocalCourses() async {
    _isLoading = true;
    notifyListeners();
    
    _localCourses = await LocalStorageService.getCourses();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadApiCourses() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _apiCourses = await ApiService.getCourses();
    } catch (e) {
      _apiCourses = [];
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLocalCourse(Course course) async {
    await LocalStorageService.addCourse(course);
    await loadLocalCourses();
  }

  Future<bool> uploadCourseToApi(Course course, int localIndex) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final success = await ApiService.postCourse(course);
      if (success) {
        await LocalStorageService.deleteCourse(localIndex);
        await loadLocalCourses();
        await loadApiCourses();
      }
      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}