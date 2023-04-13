import 'package:flutter/material.dart';
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
          title: const Text('Edit'),
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackables'),
      ),
      body: FutureBuilder<Set<String>>(
        future: _storage.getAllTrackables(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final trackables = snapshot.data ?? {};
            return TrackablesList(
              trackables: trackables,
              onTap: (trackable) async {
                await _editTrackable(initialTrackable: trackable);
                setState(() {});
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _editTrackable();
          setState(() {});
        },
        tooltip: 'New',
        child: const Icon(Icons.edit),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
