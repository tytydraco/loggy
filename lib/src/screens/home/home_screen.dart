import 'package:flutter/material.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/screens/new/new_screen.dart';

/// The home screen.
class HomeScreen extends StatefulWidget {
  /// Creates a new [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _addNewEntry() async {
    await Navigator.push(
      context,
      MaterialPageRoute<Entry>(builder: (context) => const NewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _addNewEntry(),
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
