import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('First Page')),
      drawer: AppDrawer(),
      body:
          Center(child: Text('Muhammad Asad', style: TextStyle(fontSize: 24))),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Page')),
      drawer: AppDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Button'),
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Third Page')),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Muhammad Asad', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Button'),
            ),
          ],
        ),
      ),
    );
  }
}

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  final List<String> names = [
    'Muhammad Asad',
    'Azeem',
    'Awais',
    'Zeeshan',
    'Umar'
  ];
  int index = 0;

  void toggleName() {
    setState(() {
      index = (index + 1) % names.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fourth Page')),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(names[index], style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleName,
              child: Text('Toggle Name'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            title: Text('First Page'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => FirstPage())),
          ),
          ListTile(
            title: Text('Second Page'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => SecondPage())),
          ),
          ListTile(
            title: Text('Third Page'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => ThirdPage())),
          ),
          ListTile(
            title: Text('Fourth Page'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => FourthPage())),
          ),
        ],
      ),
    );
  }
}
