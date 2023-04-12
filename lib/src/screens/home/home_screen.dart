import 'package:flutter/material.dart';
import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/screens/edit/edit_screen.dart';
import 'package:loggy/src/screens/home/entry_item.dart';
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
    final entry = await Navigator.push(
      context,
      MaterialPageRoute<Entry>(builder: (context) => const EditScreen()),
    );

    if (entry != null) {
      await _storage.addEntry(entry);
      setState(() {});
    }
  }

  Future<void> _editEntry(Entry entry) async {
    final newEntry = await Navigator.push(
      context,
      MaterialPageRoute<Entry>(
        builder: (context) => EditScreen(initialEntry: entry),
      ),
    );

    if (newEntry != null) {
      await _storage.deleteEntry(entry);
      await _storage.addEntry(newEntry);
      setState(() {});
    }
  }

  Future<void> _deleteEntry(Entry entry) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm delete'),
            content: const Text(
              'Are you sure you want to permanently delete this entry?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      await _storage.deleteEntry(entry);
      setState(() {});
    }
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
            final entries = snapshot.data ?? [];

            return ListView.builder(
              itemCount: entries.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, index) {
                final entry = entries[index];
                return EntryItem(
                  entry,
                  onEdit: () => _editEntry(entry),
                  onDelete: () => _deleteEntry(entry),
                );
              },
            );
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
