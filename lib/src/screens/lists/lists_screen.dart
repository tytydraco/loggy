import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loggy/src/data/list_storage.dart';
import 'package:loggy/src/models/loggy_list.dart';
import 'package:loggy/src/screens/home/home_screen.dart';
import 'package:loggy/src/screens/lists/lists_list.dart';
import 'package:loggy/src/utils/list_export_import/list_export_import.dart';
import 'package:loggy/src/utils/list_instance.dart';
import 'package:provider/provider.dart';

/// Manage lists.
class ListsScreen extends StatefulWidget {
  /// Creates a new [ListsScreen].
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen>
    with AutomaticKeepAliveClientMixin {
  late final _listStorage = context.read<ListStorage>();

  Future<void> _editList({LoggyList? initialList}) async {
    final newName = await showDialog<String?>(
      context: context,
      builder: (context) {
        final editController = TextEditingController();
        if (initialList != null) editController.text = initialList.name;

        return AlertDialog(
          title: Text(initialList == null ? 'Add' : 'Edit'),
          content: TextField(
            controller: editController,
            onSubmitted: (text) => Navigator.pop(context, text),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, editController.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newName == null || newName == initialList?.name) return;

    // If edited, delete the old list first.
    if (initialList != null) {
      await _listStorage.renameList(initialList, newName);
    } else {
      final newList = LoggyList(name: newName);
      await _listStorage.addList(newList);
    }

    setState(() {});
  }

  Future<void> _deleteList(LoggyList list) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm delete'),
            content: const Text(
              'Are you sure you want to permanently delete this list?',
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

    await _listStorage.deleteList(list);
    setState(() {});
  }

  /// Selects the list and moves to [HomeScreen].
  Future<void> _selectList(LoggyList list) async {
    // Pass containerized list instance to prevent backwards synchronization
    // issues.
    final listInstance = ListInstance(list, _listStorage);

    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider.value(
          value: listInstance,
          child: const HomeScreen(),
        ),
      ),
    );
  }

  /// Exports a list to clipboard.
  Future<void> _exportList(LoggyList list) async {
    await exportListToFile(list);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exported list as file.')),
      );
    }
  }

  /// Exports a list from clipboard.
  Future<void> _importList() async {
    try {
      final list = await importFileAsList();

      // Skip if we didn't pick a file.
      if (list == null) return;

      // Replace if exists already.
      await _listStorage.replaceList(list);
      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imported list from file.'),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) print(e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to import list.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
        actions: [
          IconButton(
            onPressed: _importList,
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: ListsList(
        lists: _listStorage.lists,
        onSelect: _selectList,
        onEdit: (list) => _editList(initialList: list),
        onDelete: _deleteList,
        onExport: _exportList,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'lists_new',
        onPressed: _editList,
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
