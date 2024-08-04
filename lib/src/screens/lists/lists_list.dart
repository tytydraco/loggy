import 'package:flutter/material.dart';

/// The list of existing lists.
class ListsList extends StatelessWidget {
  /// Creates a new [ListsList].
  const ListsList({
    required this.lists,
    this.onTap,
    this.onDelete,
    super.key,
  });

  /// The set of lists.
  final Set<String> lists;

  /// The handler when a list is tapped.
  final void Function(String trackable)? onTap;

  /// The handler when a list is long-pressed.
  final void Function(String trackable)? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final trackable = lists.elementAt(index);
        return ListTile(
          title: Text(trackable),
          onTap: () => onTap?.call(trackable),
          leading: IconButton(
            onPressed: () => onDelete?.call(trackable),
            icon: const Icon(Icons.delete),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: lists.length,
    );
  }
}
