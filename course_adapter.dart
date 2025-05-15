// lib/adapters/course_adapter.dart
import 'package:hive/hive.dart';
import 'course_model.dart';

class CourseAdapter extends TypeAdapter<Course> {
  @override
  final int typeId = 0;

  @override
  Course read(BinaryReader reader) {
    return Course(
      courseId: reader.read(),
      subjectName: reader.read(),
      creditHours: reader.read(),
      semesterNumber: reader.read(),
      marks: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Course obj) {
    writer.write(obj.courseId);
    writer.write(obj.subjectName);
    writer.write(obj.creditHours);
    writer.write(obj.semesterNumber);
    writer.write(obj.marks);
  }
}