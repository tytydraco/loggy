import 'package:flutter/material.dart';

/// Add a new entry.
class NewScreen extends StatefulWidget {
  /// Creates a new [NewScreen].
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New'),
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () { /* todo */ },
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}
