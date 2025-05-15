// lib/screens/local_courses_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart';

class LocalCoursesScreen extends StatelessWidget {
  const LocalCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CourseProvider>(context, listen: false);
    
    // Load data when screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadLocalCourses();
    });

    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.localCourses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.localCourses.isEmpty) {
          return const Center(child: Text('No courses in local storage'));
        }

        return ListView.builder(
          itemCount: provider.localCourses.length,
          itemBuilder: (context, index) {
            final course = provider.localCourses[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(course.subjectName),
                subtitle: Text('Course ID: ${course.courseId}'),
                trailing: IconButton(
                  icon: const Icon(Icons.cloud_upload),
                  onPressed: () async {
                    final success = await provider.uploadCourseToApi(course, index);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Course uploaded successfully')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to upload course')),
                      );
                    }
                  },
                ),
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