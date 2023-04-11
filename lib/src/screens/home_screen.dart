import 'package:flutter/material.dart';

/// The home screen.
class HomePage extends StatefulWidget {
  /// Creates a new [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () { /* todo */ },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
