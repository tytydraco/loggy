import 'package:flutter/material.dart';

/// The home screen.
class HomeScreen extends StatefulWidget {
  /// Creates a new [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
