import 'package:flutter/material.dart';
import 'package:loggy/src/models/trackable.dart';

/// The list of existing trackables.
class TrackablesList extends StatelessWidget {
  /// Creates a new [TrackablesList].
  const TrackablesList({
    required this.trackables,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  /// The set of trackables.
  final Set<Trackable> trackables;

  /// The handler when a trackable should be edited.
  final void Function(Trackable trackable) onEdit;

  /// The handler when a trackable should be deleted.
  final void Function(Trackable trackable) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final trackable = trackables.elementAt(index);
        return ListTile(
          title: Text(trackable.name),
          onTap: () => onEdit(trackable),
          leading: IconButton(
            onPressed: () => onDelete(trackable),
            icon: const Icon(Icons.delete),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: trackables.length,
    );
  }
}
