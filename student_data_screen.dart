import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentDataScreen extends StatefulWidget {
  const StudentDataScreen({super.key});

  @override
  _StudentDataScreenState createState() => _StudentDataScreenState();
}

class _StudentDataScreenState extends State<StudentDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _creditHourController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
 
  final TextEditingController _semesterNoController = TextEditingController();

  List<dynamic> _studentsData = [];
  bool _isLoading = false;

  // Modified to fetch data by user_id only
  Future<void> _fetchStudentData() async {
    if (_userIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a User ID first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _studentsData = []; // Clear previous data
    });

    try {
      // Assuming API supports filtering by user_id
      final response = await http.get(
        Uri.parse('https://devtechtop.com/management/public/api/select_data?user_id=${_userIdController.text}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Ensure we're only showing records for this user_id
          _studentsData = (data['data'] ?? []).where((record) => 
            record['user_id'].toString() == _userIdController.text
          ).toList();
        });

        if (_studentsData.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No records found for this user ID')),
          );
        }
      } else {
        throw Exception('Failed to load data. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Insert data using GET (with query params)
  Future<void> _submitStudentData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final Uri url = Uri.parse(
        'https://devtechtop.com/management/public/api/grades',
      ).replace(
        queryParameters: {
          'user_id': _userIdController.text,
          'course_name': _courseNameController.text,
          'credit_hours': _creditHourController.text,
          'marks': _marksController.text,
          
          'semester_no': _semesterNoController.text,
        },
      );

      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data added successfully!')),
        );
        _formKey.currentState!.reset();
        await _fetchStudentData(); // Refresh data for this user
      } else {
        throw Exception('Failed to add data. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Data Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _fetchStudentData,
            tooltip: 'Fetch data by User ID',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStudentForm(),
                  const SizedBox(height: 20),
                  _buildStudentDataList(),
                ],
              ),
            ),
    );
  }

  Widget _buildStudentForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Student Data Form',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  hintText: 'Enter ID to fetch or add data',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter user ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _courseNameController,
                decoration: const InputDecoration(labelText: 'Course Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _creditHourController,
                decoration: const InputDecoration(labelText: 'Credit Hour'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter credit hours';
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
                  return null;
                },
              ),
             
              TextFormField(
                controller: _semesterNoController,
                decoration: const InputDecoration(labelText: 'Semester No'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter semester number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _fetchStudentData,
                      child: const Text('Fetch Data'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitStudentData,
                      child: const Text('Submit Data'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentDataList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Records for User ID: ${_userIdController.text.isNotEmpty ? _userIdController.text : "Not specified"}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_studentsData.isEmpty)
          const Center(child: Text('No records found for this user ID'))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _studentsData.length,
            itemBuilder: (context, index) {
              final student = _studentsData[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(student['course_name'] ?? 'No Course Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User ID: ${student['user_id']}'),
                      Text('Credit Hours: ${student['credit_hours']}'),
                      Text('Marks: ${student['marks']}'),
                     
                      Text('Semester: ${student['semester_no']}'),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _courseNameController.dispose();
    _creditHourController.dispose();
    _marksController.dispose();
    _semesterNoController.dispose();
    super.dispose();
  }
}