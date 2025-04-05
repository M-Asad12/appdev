import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> studentRecords = [];
  bool isLoading = false;
  Map<String, dynamic>? studentInfo;

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
        _extractStudentInfo();
      });
    }
  }

  void _extractStudentInfo() {
    if (studentRecords.isNotEmpty) {
      final firstRecord = studentRecords[0];
      studentInfo = {
        'name': firstRecord['studentname'],
        'fatherName': firstRecord['fathername'],
        'program': firstRecord['progname'],
        'shift': firstRecord['shift'],
        'rollNo': firstRecord['rollno'],
      };
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
          _extractStudentInfo();
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
      studentInfo = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All data erased')),
    );
  }

  Map<String, List<dynamic>> _groupBySemester() {
    final Map<String, List<dynamic>> semesterMap = {};
    
    for (var record in studentRecords) {
      final semester = record['mysemester'].toString();
      if (!semesterMap.containsKey(semester)) {
        semesterMap[semester] = [];
      }
      semesterMap[semester]!.add(record);
    }
    
    return semesterMap;
  }

  Widget _buildStudentInfoCard() {
    if (studentInfo == null) return Container();
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', studentInfo!['name']),
            _buildInfoRow('Father Name', studentInfo!['fatherName']),
            _buildInfoRow('Program', studentInfo!['program']),
            _buildInfoRow('Shift', studentInfo!['shift']),
            _buildInfoRow('Roll No', studentInfo!['rollNo']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterExpansionPanel(String semester, List<dynamic> courses) {
    return ExpansionTile(
      title: Text(
        'Semester $semester',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Course Code')),
              DataColumn(label: Text('Course Title')),
              DataColumn(label: Text('Credit Hrs'), numeric: true),
              DataColumn(label: Text('Marks'), numeric: true),
              DataColumn(label: Text('Status')),
            ],
            rows: courses.map((course) {
              return DataRow(
                cells: [
                  DataCell(Text(course['coursecode'] ?? 'N/A')),
                  DataCell(Text(course['coursetitle'] ?? 'N/A')),
                  DataCell(Text(course['credithours'] ?? 'N/A')),
                  DataCell(Text(course['obtainedmarks']?.toString() ?? 'N/A')),
                  DataCell(Text(course['consider_status'] ?? 'N/A')),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final semesterGroups = _groupBySemester();
    final semesters = semesterGroups.keys.toList()..sort();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Academic Record'),
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
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildStudentInfoCard(),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Academic Record',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      ...semesters.map((semester) => 
                        _buildSemesterExpansionPanel(semester, semesterGroups[semester]!)
                      ).toList(),
                    ],
                  ),
                ),
    );
  }
}