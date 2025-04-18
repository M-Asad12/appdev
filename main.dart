import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'home_screen.dart';
import 'bgnu_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Navigator',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/bgnu': (context) => const BGNUScreen(),
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}