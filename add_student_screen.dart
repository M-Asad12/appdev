import 'package:flutter/material.dart';
import 'student_model.dart';

class AddStudentScreen extends StatefulWidget {
  final Function(StudentRecord) onSave;

  const AddStudentScreen({super.key, required this.onSave});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late StudentRecord _studentRecord;

  @override
  void initState() {
    super.initState();
    _studentRecord = StudentRecord(
      studentname: '',
      fathername: '',
      progname: '',
      shift: '',
      rollno: '',
      coursecode: '',
      coursetitle: '',
      credithours: '',
      obtainedmarks: '',
      mysemester: '',
      consider_status: 'E',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Student Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Student Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter student name' : null,
                  onSaved: (value) => _studentRecord.studentname = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Father Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter father name' : null,
                  onSaved: (value) => _studentRecord.fathername = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Program Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter program name' : null,
                  onSaved: (value) => _studentRecord.progname = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Shift'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter shift' : null,
                  onSaved: (value) => _studentRecord.shift = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Roll No'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter roll number' : null,
                  onSaved: (value) => _studentRecord.rollno = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Course Code'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter course code' : null,
                  onSaved: (value) => _studentRecord.coursecode = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Course Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter course title' : null,
                  onSaved: (value) => _studentRecord.coursetitle = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Credit Hours'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter credit hours' : null,
                  onSaved: (value) => _studentRecord.credithours = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Obtained Marks'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter obtained marks' : null,
                  onSaved: (value) => _studentRecord.obtainedmarks = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Semester'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter semester' : null,
                  onSaved: (value) => _studentRecord.mysemester = value!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Save Record'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSave(_studentRecord);
      Navigator.of(context).pop();
    }
  }
}