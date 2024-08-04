import 'package:flutter/material.dart';
import 'package:loggy/src/data/list_storage.dart';
import 'package:loggy/src/data/local_storage.dart';
import 'package:loggy/src/screens/home/home_screen.dart';
import 'package:loggy/src/screens/lists/lists_list.dart';
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
    final newList = await showDialog<String?>(
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

    if (newList == null) return;

    await _listStorage.addList(newList);

    setState(() {});
  }

  Future<void> _deleteList(String list) async {
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

    if (confirmed) {
      await _listStorage.deleteList(list);
      setState(() {});
    }
  }

  Future<void> _selectList(String list) async {
    final localStorage = LocalStorage(suffix: list);
    await localStorage.init();

    if (mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => Provider.value(
            value: localStorage,
            child: const HomeScreen(),
          ),
        ),
      );
    }
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
        onPressed: () async {
          await _addList();
          setState(() {});
        },
        tooltip: 'New',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
