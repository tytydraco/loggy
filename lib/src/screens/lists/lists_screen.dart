import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _gzipCodec = GZipCodec(level: 9);

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
    final json = jsonEncode(list);
    final gzip = _gzipCodec.encode(utf8.encode(json));
    final base64 = base64Encode(gzip);
    await Clipboard.setData(ClipboardData(text: base64));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied list to clipboard (GZIP+Base64).'),
        ),
      );
    }
  }

  /// Exports a list from clipboard.
  Future<void> _importList() async {
    final clipboardData = await Clipboard.getData('text/plain');

    try {
      final base64 = clipboardData!.text!;
      final gzip = _gzipCodec.decode(base64Decode(base64));
      final json = utf8.decode(gzip);
      final listJson = jsonDecode(json) as Map<String, dynamic>;
      final list = LoggyList.fromJson(listJson);

      // Replace if exists already.
      await _listStorage.replaceList(list);
      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imported list from clipboard.'),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) print(e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to parse clipboard.')),
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
            icon: const Icon(Icons.paste),
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
