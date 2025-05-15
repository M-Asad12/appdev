// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'course_model.dart';

class ApiService {
  static const String baseUrl = 'https://donors.asadshub.online/api';
  
  // Get courses from API
  static Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/get'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Course.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }
  
  // Post course to API
  static Future<bool> postCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/post'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toMap()),
    );
    
    return response.statusCode == 200;
  }
}