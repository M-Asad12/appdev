import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi-Subject Marks Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MultiSubjectMarksCalculator(),
    );
  }
}

class MultiSubjectMarksCalculator extends StatefulWidget {
  const MultiSubjectMarksCalculator({super.key});

  @override
  State<MultiSubjectMarksCalculator> createState() =>
      _MultiSubjectMarksCalculatorState();
}

class _MultiSubjectMarksCalculatorState
    extends State<MultiSubjectMarksCalculator> {
  final List<String> subjects = [
    'Artificial Intelligence',
    'Database',
    'Mobile App Development',
    'Information Security',
    'Compiler Construction',
  ];
  final Map<String, double?> subjectMarks = {};

  String? selectedSubject;
  final TextEditingController marksController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();

  double? overallPercentage;
  String? overallGrade;

  @override
  void initState() {
    super.initState();
    _loadMarks();
  }

  // Load marks from SQLite database
  Future<void> _loadMarks() async {
    final data = await DBHelper.getMarks();
    setState(() {
      subjectMarks.clear();
      for (var entry in data) {
        subjectMarks[entry['studentName']] = entry['marks'];
      }
    });
  }

  // Add marks for the selected subject and student name
  Future<void> addMarks() async {
    if (studentNameController.text.isEmpty ||
        selectedSubject == null ||
        marksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter student name, select a subject and enter marks!'),
        ),
      );
      return;
    }

    double marks = double.tryParse(marksController.text) ?? 0;
    if (marks < 0 || marks > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marks must be between 0 and 100!')),
      );
      return;
    }

    // Save the data to SQLite
    await DBHelper.insertMarks(studentNameController.text, selectedSubject!, marks);
    marksController.clear(); // Clear input after submission
    studentNameController.clear(); // Clear student name input after submission
    _loadMarks(); // Reload marks from database
  }

  // Calculate overall result
  void calculateOverallResult() {
    if (subjectMarks.values.any((mark) => mark == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter marks for all subjects!')),
      );
      return;
    }

    double total = subjectMarks.values.fold(0, (sum, mark) => sum + (mark ?? 0));
    double percentage = total / subjects.length;

    setState(() {
      overallPercentage = percentage;
      overallGrade = _calculateGrade(percentage);
    });
  }

  // Grade calculation logic
  String _calculateGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi-Subject Marks Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Student Name Input
            TextField(
              controller: studentNameController,
              decoration: const InputDecoration(
                labelText: 'Enter Student Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Dropdown for subjects
            DropdownButtonFormField<String>(
              value: selectedSubject,
              hint: const Text('Select Subject'),
              items: subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Marks input field
            TextField(
              controller: marksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Marks (Out of 100)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Button to add marks for the selected subject
            ElevatedButton(
              onPressed: addMarks,
              child: const Text('Add Marks'),
            ),

            const SizedBox(height: 20),

            // Display all student marks
            const Text('Student Marks:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: DBHelper.getMarks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text('Error loading data');
                }

                final data = snapshot.data;

                return Column(
                  children: data!.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text('${entry['studentName']} - ${entry['subject']}: '),
                          Text(
                            entry['marks'] != null
                                ? '${entry['marks'].toStringAsFixed(2)}'
                                : 'Not entered',
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 30),

            // Submit button (calculates final result)
            ElevatedButton(
              onPressed: calculateOverallResult,
              child: const Text('Calculate Overall Result'),
            ),

            const SizedBox(height: 20),

            // Display final result
            if (overallPercentage != null && overallGrade != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Overall Result:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Percentage: ${overallPercentage!.toStringAsFixed(2)}%',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Grade: $overallGrade',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
