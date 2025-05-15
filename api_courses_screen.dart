// lib/screens/api_courses_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';

class ApiCoursesScreen extends StatelessWidget {
  const ApiCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CourseProvider>(context, listen: false);
    
    // Load data when screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadApiCourses();
    });

    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.apiCourses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.apiCourses.isEmpty) {
          return const Center(child: Text('No courses from API'));
        }

        return ListView.builder(
          itemCount: provider.apiCourses.length,
          itemBuilder: (context, index) {
            final course = provider.apiCourses[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(course.subjectName),
                subtitle: Text('Course ID: ${course.courseId}'),
                onTap: () {
                  // Show details
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(course.subjectName),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Course ID: ${course.courseId}'),
                          Text('Credit Hours: ${course.creditHours}'),
                          Text('Semester: ${course.semesterNumber}'),
                          Text('Marks: ${course.marks}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}