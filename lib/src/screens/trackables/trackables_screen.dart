import 'package:flutter/material.dart';
import 'package:loggy/src/models/trackable.dart';
import 'package:loggy/src/screens/trackables/trackables_list.dart';
import 'package:loggy/src/utils/list_instance.dart';
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
  late final _listInstance = context.read<ListInstance>();

  Future<void> _editTrackable({Trackable? initialTrackable}) async {
    final newTrackable = await showDialog<Trackable?>(
      context: context,
      builder: (context) {
        final editController = TextEditingController();
        if (initialTrackable != null) {
          editController.text = initialTrackable.name;
        }

        return AlertDialog(
          title: Text(initialTrackable == null ? 'Add' : 'Edit'),
          content: TextField(
            controller: editController,
            onSubmitted: (text) => Navigator.pop(
              context,
              Trackable(name: editController.text, boolean: true),
            ),
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
              onPressed: () => Navigator.pop(
                context,
                Trackable(name: editController.text, boolean: true),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newTrackable == null || newTrackable == initialTrackable) return;

    // If edited, rename the trackable. Otherwise, just add it.
    if (initialTrackable != null) {
      _listInstance.list.renameTrackable(initialTrackable, newTrackable);
    } else {
      _listInstance.list.trackables.add(newTrackable);
    }

    setState(() {});

    await _listInstance.save();
  }

  Future<void> _deleteTrackable(Trackable trackable) async {
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

    if (!confirmed) return;

    // Update entries for deleted trackable.
    _listInstance.list.renameTrackable(trackable, null);

    setState(() {
      _listInstance.list.trackables.remove(trackable);
    });

    await _listInstance.save();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackables'),
      ),
      body: TrackablesList(
        trackables: _listInstance.list.trackables,
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
