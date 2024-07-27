import 'package:flutter/material.dart';

/// The list of existing trackables.
class TrackablesList extends StatelessWidget {
  /// Creates a new [TrackablesList].
  const TrackablesList({
    required this.trackables,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  /// The set of trackables.
  final Set<String> trackables;

  /// The handler when a trackable is tapped.
  final void Function(String trackable)? onEdit;

  /// The handler when a trackable is long-pressed.
  final void Function(String trackable)? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final trackable = trackables.elementAt(index);
        return ListTile(
          title: Text(trackable),
          onTap: () => onEdit?.call(trackable),
          leading: IconButton(
            onPressed: () => onDelete?.call(trackable),
            icon: const Icon(Icons.delete),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: trackables.length,
    );
  }
}
