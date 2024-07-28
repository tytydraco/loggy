import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late final _storage = context.read<StorageBase>();

  Future<void> _addNewEntry() async {
    final entry = await Navigator.push(
      context,
      MaterialPageRoute<Entry>(builder: (context) => const EditScreen()),
    );

    if (entry != null) {
      await _storage.addEntry(entry);

      // Sometimes the stored data differs from the internal state; synchronize.
      await _storage.getAllEntries();

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

  Future<void> _exportEntries() async {
    final json = jsonEncode(_storage.entries.toList());
    final base64 = base64Encode(utf8.encode(json));
    await Clipboard.setData(ClipboardData(text: base64));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard.')),
      );
    }
  }

  Future<void> _importEntries() async {
    final clipboardData = await Clipboard.getData('text/plain');

    if (clipboardData != null && clipboardData.text != null) {
      final base64 = clipboardData.text!;

      try {
        final json = utf8.decode(base64Decode(base64));
        final entries = (jsonDecode(json) as List<dynamic>)
            .map((e) => Entry.fromJson(e as Map<String, dynamic>));

        await _storage.setAllEntries(Set.from(entries));
        setState(() {});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imported from clipboard.')),
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to parse clipboard.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: _exportEntries,
            icon: const Icon(Icons.upload),
          ),
          IconButton(
            onPressed: _importEntries,
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _storage.entries.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          final entry = _storage.entries.elementAt(index);
          return EntryItem(
            entry,
            onEdit: () => _editEntry(entry),
            onDelete: () => _deleteEntry(entry),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_new',
        onPressed: () async => _addNewEntry(),
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
