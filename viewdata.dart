import 'package:flutter/material.dart';
import 'datacontrol.dart';

class ViewData extends StatefulWidget {
  @override
  _ViewDataState createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Load users from SharedPreferences
  void _loadUsers() async {
    List<Map<String, dynamic>> storedUsers = await DataControl.getUsers();
    setState(() {
      users = storedUsers;
    });
  }

  // Delete user and refresh data
  void _deleteUser(int index) async {
    await DataControl.deleteUser(index);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stored User Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: users.isEmpty
            ? Center(
                child:
                    Text("No Data Available", style: TextStyle(fontSize: 16)))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(color: Colors.black),
                  columns: [
                    DataColumn(
                        label: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Email',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Password',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Status',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Actions',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: List.generate(users.length, (index) {
                    var user = users[index];
                    return DataRow(
                      cells: [
                        DataCell(Text(user['name'])),
                        DataCell(Text(user['email'])),
                        DataCell(Text(user['password'])),
                        DataCell(
                          Icon(
                            user['isActive']
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: user['isActive'] ? Colors.green : Colors.red,
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(index),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
      ),
    );
  }
}
