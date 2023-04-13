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

  Future<void> _addNewTrackable() async {
    // TODO(tytydraco): add trackables and display existing ones
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackables'),
      ),
      body: TrackablesList(
        trackables: {},
        onTap: (trackable) {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _addNewTrackable(),
        tooltip: 'New',
        child: const Icon(Icons.edit),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
