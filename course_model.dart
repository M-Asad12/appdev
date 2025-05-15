// lib/models/course_model.dart
class Course {
  final String courseId;
  final String subjectName;
  final int creditHours;
  final int semesterNumber;
  final int marks;

  Course({
    required this.courseId,
    required this.subjectName,
    required this.creditHours,
    required this.semesterNumber,
    required this.marks,
  });

  // Convert to Map for Hive and API
  Map<String, dynamic> toMap() {
    return {
      'course_id': courseId,
      'subject_name': subjectName,
      'credit_hours': creditHours,
      'semester_number': semesterNumber,
      'marks': marks,
    };
  }

  // Create from Map
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      courseId: map['course_id'] ?? '',
      subjectName: map['subject_name'] ?? '',
      creditHours: map['credit_hours'] ?? 0,
      semesterNumber: map['semester_number'] ?? 0,
      marks: map['marks'] ?? 0,
    );
  }
}