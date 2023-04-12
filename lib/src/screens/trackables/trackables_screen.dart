import 'package:flutter/material.dart';
import 'package:loggy/src/data/storage_base.dart';
import 'package:provider/provider.dart';

/// Manage trackable activities.
class TrackablesScreen extends StatefulWidget {
  /// Creates a new [TrackablesScreen].
  const TrackablesScreen({super.key});

  @override
  State<TrackablesScreen> createState() => _TrackablesScreenState();
}

class _TrackablesScreenState extends State<TrackablesScreen> {
  late final _storage = context.read<StorageBase>();

  Future<void> _addNewTrackable() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackables'),
      ),
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _addNewTrackable(),
        tooltip: 'New',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
