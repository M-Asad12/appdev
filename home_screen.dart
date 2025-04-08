import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_student_screen.dart';
import 'student_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> studentRecords = [];
  bool isLoading = false;
  Map<String, List<dynamic>> studentsMap = {};

  @override
  void initState() {
    super.initState();
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('student_data');
    
    if (data != null) {
      setState(() {
        studentRecords = json.decode(data);
        _organizeStudents();
      });
    }
  }

  void _organizeStudents() {
    studentsMap = {};
    for (var record in studentRecords) {
      final rollNo = record['rollno'];
      if (!studentsMap.containsKey(rollNo)) {
        studentsMap[rollNo] = [];
      }
      studentsMap[rollNo]!.add(record);
    }
  }

  Future<void> _fetchDataFromApi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://bgnuerp.online/api/gradeapi'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('student_data', json.encode(data));
        
        setState(() {
          studentRecords = data;
          _organizeStudents();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load data from API')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _eraseAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('student_data');
    
    setState(() {
      studentRecords = [];
      studentsMap = {};
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All data erased')),
    );
  }

  Future<void> _addNewStudent(StudentRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      studentRecords.add(record.toJson());
      _organizeStudents();
    });
    await prefs.setString('student_data', json.encode(studentRecords));
  }

  Widget _buildStudentCard(String rollNo, List<dynamic> records) {
    final firstRecord = records.first;
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text('${firstRecord['studentname']} - $rollNo'),
        subtitle: Text(firstRecord['progname']),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Father: ${firstRecord['fathername']}'),
                Text('Shift: ${firstRecord['shift']}'),
                const SizedBox(height: 10),
                const Text('Courses:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...records.map((course) => ListTile(
                  title: Text(course['coursetitle']),
                  subtitle: Text('Code: ${course['coursecode']} | Marks: ${course['obtainedmarks']}'),
                  trailing: Text('Sem ${course['mysemester']}'),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _eraseAllData,
            tooltip: 'Erase All Data',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDataFromApi,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddStudentScreen(onSave: _addNewStudent),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : studentRecords.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No student data available'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchDataFromApi,
                        child: const Text('Load Student Data'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: studentsMap.entries
                      .map((entry) => _buildStudentCard(entry.key, entry.value))
                      .toList(),
                ),
    );
  }
}