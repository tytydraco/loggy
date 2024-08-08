import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loggy/src/data/list_storage.dart';
import 'package:loggy/src/models/loggy_list.dart';
import 'package:loggy/src/screens/home/home_screen.dart';
import 'package:loggy/src/screens/lists/lists_list.dart';
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

  Future<void> _addList() async {
    final newListName = await showDialog<String?>(
      context: context,
      builder: (context) {
        final editController = TextEditingController();

        return AlertDialog(
          title: const Text('Add'),
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

    if (newListName == null) return;

    final newList = LoggyList(
      name: newListName,
      entries: const {},
      trackables: const {},
    );

    await _listStorage.addList(newList);

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
        builder: (_) => Provider.value(
          value: listInstance,
          child: const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
      ),
      body: ListsList(
        lists: _listStorage.lists,
        onTap: _selectList,
        onDelete: _deleteList,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'lists_new',
        onPressed: _addList,
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
