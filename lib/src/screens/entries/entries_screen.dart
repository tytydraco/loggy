import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/screens/edit/edit_screen.dart';
import 'package:loggy/src/screens/entries/entry_item.dart';
import 'package:loggy/src/utils/list_instance.dart';
import 'package:provider/provider.dart';

/// The entries screen.
class EntriesScreen extends StatefulWidget {
  /// Creates a new [EntriesScreen].
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen>
    with AutomaticKeepAliveClientMixin {
  late final _listInstance = context.read<ListInstance>();

  /// Edit an existing entry or create a new one by passing null as the [entry].
  Future<void> _editEntry({Entry? entry}) async {
    // Take user to the edit screen to create a new entry.
    final newEntry = await Navigator.push(
      context,
      MaterialPageRoute<Entry>(
        builder: (context) => Provider.value(
          value: _listInstance.list,
          updateShouldNotify: (_, __) => false,
          child: EditScreen(initialEntry: entry),
        ),
      ),
    );

    if (newEntry == null) return;

    setState(() {
      // If this is an edited entry, remove the old, outdated entry.
      if (entry != null) _listInstance.list.entries.remove(entry);
      _listInstance.list.entries.add(newEntry);
    });

    await _listInstance.save();
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

    if (!confirmed) return;

    setState(() {
      _listInstance.list.entries.remove(entry);
    });

    await _listInstance.save();
  }

  Future<void> _exportEntries() async {
    final json = jsonEncode(_listInstance.list.entries.toList());
    final base64 = base64Encode(utf8.encode(json));
    await Clipboard.setData(ClipboardData(text: base64));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied entries to clipboard.')),
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

        setState(() {
          _listInstance.list.entries
            ..clear()
            ..addAll(Set.from(entries));
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Imported entries from clipboard.')),
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
        title: const Text('Entries'),
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
        itemCount: _listInstance.list.entries.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (_, index) {
          final entry = _listInstance.list.entries.elementAt(index);
          return EntryItem(
            entry,
            onEdit: () => _editEntry(entry: entry),
            onDelete: () => _deleteEntry(entry),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'entries_new',
        onPressed: () async => _editEntry(),
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
