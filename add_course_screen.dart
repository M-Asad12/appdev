// lib/screens/add_course_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';
import 'course_model.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseIdController = TextEditingController();
  final _subjectNameController = TextEditingController();
  final _creditHoursController = TextEditingController();
  final _semesterController = TextEditingController();
  final _marksController = TextEditingController();

  @override
  void dispose() {
    _courseIdController.dispose();
    _subjectNameController.dispose();
    _creditHoursController.dispose();
    _semesterController.dispose();
    _marksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _courseIdController,
                decoration: const InputDecoration(labelText: 'Course ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _subjectNameController,
                decoration: const InputDecoration(labelText: 'Subject Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter subject name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _creditHoursController,
                decoration: const InputDecoration(labelText: 'Credit Hours'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter credit hours';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _semesterController,
                decoration: const InputDecoration(labelText: 'Semester Number'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter semester number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _marksController,
                decoration: const InputDecoration(labelText: 'Marks'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter marks';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final course = Course(
                      courseId: _courseIdController.text,
                      subjectName: _subjectNameController.text,
                      creditHours: int.parse(_creditHoursController.text),
                      semesterNumber: int.parse(_semesterController.text),
                      marks: int.parse(_marksController.text),
                    );

                    final provider = Provider.of<CourseProvider>(
                      context,
                      listen: false,
                    );
                    await provider.addLocalCourse(course);

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Save Course Locally'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}