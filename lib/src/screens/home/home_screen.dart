import 'package:flutter/material.dart';
import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/screens/home/entry_list.dart';
import 'package:loggy/src/screens/new/new_screen.dart';
import 'package:provider/provider.dart';

/// The home screen.
class HomeScreen extends StatefulWidget {
  /// Creates a new [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _storage = context.read<StorageBase>();

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
      body: FutureBuilder<List<Entry>>(
        future: _storage.getAllEntries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data ?? [];
            return EntryList(entries: data);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _addNewEntry(),
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }
}
