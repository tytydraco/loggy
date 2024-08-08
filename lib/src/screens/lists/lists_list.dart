import 'package:flutter/material.dart';
import 'package:loggy/src/models/loggy_list.dart';

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
  final Set<LoggyList> lists;

  /// The handler when a list is tapped.
  final void Function(LoggyList list)? onTap;

  /// The handler when a list is long-pressed.
  final void Function(LoggyList list)? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final list = lists.elementAt(index);
        return ListTile(
          title: Text(list.name),
          onTap: () => onTap?.call(list),
          leading: IconButton(
            onPressed: () => onDelete?.call(list),
            icon: const Icon(Icons.delete),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: lists.length,
    );
  }
}
