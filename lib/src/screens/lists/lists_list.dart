import 'package:flutter/material.dart';
import 'package:loggy/src/models/loggy_list.dart';

/// The list of existing lists.
class ListsList extends StatelessWidget {
  /// Creates a new [ListsList].
  const ListsList({
    required this.lists,
    required this.onTap,
    required this.onDelete,
    required this.onExport,
    super.key,
  });

  /// The set of lists.
  final Set<LoggyList> lists;

  /// The handler when a list is tapped.
  final void Function(LoggyList list) onTap;

  /// The handler when a list is long-pressed.
  final void Function(LoggyList list) onDelete;

  /// The handler when a list should be exported.
  final void Function(LoggyList list) onExport;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final list = lists.elementAt(index);
        return ListTile(
          title: Text(list.name),
          onTap: () => onTap(list),
          leading: IconButton(
            onPressed: () => onDelete(list),
            icon: const Icon(Icons.delete),
          ),
          trailing: IconButton(
            onPressed: () => onExport(list),
            icon: const Icon(Icons.copy),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: lists.length,
    );
  }
}
