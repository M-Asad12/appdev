import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Calculator'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MathPage()),
                );
              },
            ),
            ListTile(
              title: Text('Result'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text('Home Page')),
    );
  }
}

class MathPage extends StatefulWidget {
  @override
  _MathPageState createState() => _MathPageState();
}

class _MathPageState extends State<MathPage> {
  double operand1 = 0;
  double operand2 = 0;
  String operation = '';
  String result = '';

  void calculateResult() {
    double res = 0;
    switch (operation) {
      case 'Add':
        res = operand1 + operand2;
        break;
      case 'Subtract':
        res = operand1 - operand2;
        break;
      case 'Multiply':
        res = operand1 * operand2;
        break;
      case 'Divide':
        if (operand2 != 0) {
          res = operand1 / operand2;
        } else {
          setState(() {
            result = "Cannot divide by zero!";
          });
          return;
        }
        break;
      default:
        res = 0;
    }
    setState(() {
      result = res.toStringAsFixed(2); // Format to 2 decimal places
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math Operations'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Math Operations",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Operand 1',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
              ),
              onChanged: (value) {
                operand1 = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Operand 2',
                labelStyle: TextStyle(color: Colors.teal),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
              ),
              onChanged: (value) {
                operand2 = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      operation = 'Add';
                      calculateResult();
                    });
                  },
                  child: Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      operation = 'Subtract';
                      calculateResult();
                    });
                  },
                  child: Text('Subtract'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      operation = 'Multiply';
                      calculateResult();
                    });
                  },
                  child: Text('Multiply'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      operation = 'Divide';
                      calculateResult();
                    });
                  },
                  child: Text('Divide'),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal, width: 2),
              ),
              child: Text(
                result.isEmpty ? 'Result will appear here' : 'Result: $result',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentPage extends StatelessWidget {
  final List<Map<String, String>> students = [
    {"name": "M.ZEESHAN", "roll": "M31", "department": "Computer Science"},
    {"name": "M.AWAIS", "roll": "M34", "department": "Computer Science"},
    {"name": "AZ SHAKIR", "roll": "M08", "department": "Computer Science"},
    {"name": "ASAD MUSTAFA", "roll": "M12", "department": "Computer Science"},
    {"name": "UMAR FAROOQ", "roll": "M01", "department": "Computer Science"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Data'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              // Allows table to take available space
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Scrollbar(
                  // Adds scrollbar for better UX
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Horizontal scrolling
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Roll No')),
                        DataColumn(label: Text('Department')),
                      ],
                      rows: students
                          .map((student) => DataRow(cells: [
                                DataCell(Text(student['name']!)),
                                DataCell(Text(student['roll']!)),
                                DataCell(Text(student['department']!)),
                              ]))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MathPage()),
                );
              },
              child: Text('Go to Math Operations'),
            ),
          ],
        ),
      ),
    );
  }
}
