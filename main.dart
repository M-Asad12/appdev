import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pakistan Flag',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pakistan Flag App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FlagPage()),
            );
          },
          child: const Text('Show Pakistan Flag'),
        ),
      ),
    );
  }
}

class FlagPage extends StatelessWidget {
  const FlagPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pakistan Flag'),
      ),
      body: Center(
        child: Image.network(
          'data:image/jpeg;base64,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',
          width: 300,
          height: 200,
          fit: BoxFit.contain,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return const Text('Could not load the flag image');
          },
        ),
      ),
    );
  }
}