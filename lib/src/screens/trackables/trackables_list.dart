import 'package:flutter/material.dart';

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
  final Set<String> trackables;

  /// The handler when a trackable should be edited.
  final void Function(String trackable) onEdit;

  /// The handler when a trackable should be deleted.
  final void Function(String trackable) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final trackable = trackables.elementAt(index);
        return ListTile(
          title: Text(trackable),
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
