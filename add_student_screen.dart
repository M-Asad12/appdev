import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _apiResponse; // To store the full API response

  // Form fields
  String _user_id = '';
  String _course_name = '';
  String _credit_hours = '';
  String _marks = '';
  String _semester_no = '';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _apiResponse = null;
      });

      try {
        // Convert user_id to integer
        final int? userId = int.tryParse(_user_id);
        if (userId == null) {
          throw Exception('User ID must be a valid number');
        }

        // Print the data being sent for debugging
        print('Sending data: ${{
          'user_id': userId,
          'course_name': _course_name,
          'credit_hours': _credit_hours,
          'marks': _marks,
          'semester_no': _semester_no,
        }}');

        final Uri uri = Uri.parse('https://devtechtop.com/management/public/api/grades')
          .replace(queryParameters: {
            'user_id': userId.toString(),
            'course_name': _course_name,
            'credit_hours': _credit_hours, // Note: API might expect 'credit_hours' with typo
            'marks': _marks,
            'semester_no': _semester_no,
          });

        final response = await http.get(uri);
        final responseData = json.decode(response.body);

        setState(() {
          _apiResponse = 'Status: ${response.statusCode}\nResponse: ${response.body}';
        });

        if (response.statusCode == 200) {
          // Check if the response actually indicates success
          if (responseData['success'] == true || 
              response.body.toLowerCase().contains('success')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Grade inserted successfully!')),
            );
            _formKey.currentState?.reset();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('API reported success but no data inserted: ${response.body}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'User ID (Number)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (int.tryParse(value) == null) return 'Must be a number';
                    return null;
                  },
                  onSaved: (value) => _user_id = value!,
                ),
                
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Course Name'),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  onSaved: (value) => _course_name = value!,
                ),
                
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Credit Hours'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  onSaved: (value) => _credit_hours = value!,
                ),
                
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Marks'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  onSaved: (value) => _marks = value!,
                ),
                
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Semester Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  onSaved: (value) => _semester_no = value!,
                ),
                
                const SizedBox(height: 20),
                
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Submit'),
                      ),
                
                if (_apiResponse != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SelectableText(
                      _apiResponse!,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}