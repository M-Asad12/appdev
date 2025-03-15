import 'package:flutter/material.dart';
import 'datacontrol.dart';
import 'viewdata.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isActive = false;

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> newUser = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'isActive': _isActive,
      };

      await DataControl.saveUser(newUser);

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      setState(() => _isActive = false);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewData()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your name' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your email' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter your password' : null,
                  ),
                  Row(
                    children: [
                      Text("Active"),
                      Radio(
                        value: true,
                        groupValue: _isActive,
                        onChanged: (value) =>
                            setState(() => _isActive = value as bool),
                      ),
                      Text("Inactive"),
                      Radio(
                        value: false,
                        groupValue: _isActive,
                        onChanged: (value) =>
                            setState(() => _isActive = value as bool),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: _submitData, child: Text('Submit')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
