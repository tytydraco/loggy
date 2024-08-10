import 'dart:async';

import 'package:flutter/material.dart';
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

  /// Called when the list is updated for any reason. Refresh the screen to
  /// provide updated analysis.
  void _listInstanceListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Listen for changes made to the list to update the entries.
    _listInstance.addListener(_listInstanceListener);
  }

  /// Edit an existing entry or create a new one by passing null as the [entry].
  Future<void> _editEntry({Entry? entry}) async {
    // Take user to the edit screen to create a new entry.
    final newEntry = await Navigator.push(
      context,
      MaterialPageRoute<Entry>(
        builder: (context) => EditScreen(
          list: _listInstance.list,
          initialEntry: entry,
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
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
  void dispose() {
    _listInstance.removeListener(_listInstanceListener);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
