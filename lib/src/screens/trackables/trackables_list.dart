import 'package:flutter/material.dart';

/// The list of existing trackables.
class TrackablesList extends StatelessWidget {
  /// Creates a new [TrackablesList].
  const TrackablesList({
    super.key,
    required this.trackables,
    this.onEdit,
    this.onDelete,
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
          onLongPress: () => onDelete?.call(trackable),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: trackables.length,
    );
  }
}
