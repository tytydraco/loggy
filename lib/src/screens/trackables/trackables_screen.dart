import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/screens/trackables/trackables_list.dart';
import 'package:provider/provider.dart';

/// Manage trackable activities.
class TrackablesScreen extends StatefulWidget {
  /// Creates a new [TrackablesScreen].
  const TrackablesScreen({super.key});

  @override
  State<TrackablesScreen> createState() => _TrackablesScreenState();
}

class _TrackablesScreenState extends State<TrackablesScreen>
    with AutomaticKeepAliveClientMixin {
  late final _storage = context.read<StorageBase>();

  Future<void> _editTrackable({String? initialTrackable}) async {
    final newTrackable = await showDialog<String?>(
      context: context,
      builder: (context) {
        final editController = TextEditingController();
        if (initialTrackable != null) editController.text = initialTrackable;

        return AlertDialog(
          title: Text(initialTrackable == null ? 'Add' : 'Edit'),
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

    if (newTrackable == null || newTrackable == initialTrackable) return;

    if (initialTrackable != null) {
      await _storage.deleteTrackable(initialTrackable);
    }

    await _storage.addTrackable(newTrackable);

    setState(() {});
  }

  Future<void> _deleteTrackable(String trackable) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm delete'),
            content: const Text(
              'Are you sure you want to permanently delete this trackable?',
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
      await _storage.deleteTrackable(trackable);
      setState(() {});
    }
  }

  Future<void> _exportTrackables() async {
    final json = jsonEncode(_storage.trackables.toList());
    final base64 = base64Encode(utf8.encode(json));
    await Clipboard.setData(ClipboardData(text: base64));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied trackables to clipboard.')),
      );
    }
  }

  Future<void> _importTrackables() async {
    final clipboardData = await Clipboard.getData('text/plain');

    if (clipboardData != null && clipboardData.text != null) {
      final base64 = clipboardData.text!;

      try {
        final json = utf8.decode(base64Decode(base64));
        final trackables = (jsonDecode(json) as List<dynamic>).cast<String>();

        await _storage.setAllTrackables(Set.from(trackables));
        setState(() {});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Imported trackables from clipboard.'),
            ),
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
        title: const Text('Trackables'),
        actions: [
          IconButton(
            onPressed: _exportTrackables,
            icon: const Icon(Icons.upload),
          ),
          IconButton(
            onPressed: _importTrackables,
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: TrackablesList(
        trackables: _storage.trackables,
        onEdit: (trackable) => _editTrackable(initialTrackable: trackable),
        onDelete: _deleteTrackable,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'trackables_new',
        onPressed: () async {
          await _editTrackable();
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
