import 'package:flutter/material.dart';
import 'add_student_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Records',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StudentRecordsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StudentRecordsScreen extends StatefulWidget {
  const StudentRecordsScreen({super.key});

  @override
  State<StudentRecordsScreen> createState() => _StudentRecordsScreenState();
}

class _StudentRecordsScreenState extends State<StudentRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Records'),
      ),
      body: const Center(
        child: Text('Press + to add new student record'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddStudent(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddStudent(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddStudentScreen(),
      ),
    );
  }
}