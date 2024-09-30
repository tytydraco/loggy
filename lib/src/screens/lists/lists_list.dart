import 'package:flutter/material.dart';
import 'package:loggy/src/models/loggy_list.dart';

/// The list of existing lists.
class ListsList extends StatelessWidget {
  /// Creates a new [ListsList].
  const ListsList({
    required this.lists,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
    required this.onExport,
    super.key,
  });

  /// The set of lists.
  final Set<LoggyList> lists;

  /// The handler when a list should be selected.
  final void Function(LoggyList list) onSelect;

  /// The handler when a list should be edited.
  final void Function(LoggyList list) onEdit;

  /// The handler when a list should be deleted.
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
          onTap: () => onSelect(list),
          leading: IconButton(
            onPressed: () => onDelete(list),
            icon: const Icon(Icons.delete),
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => onEdit(list),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => onExport(list),
                icon: const Icon(Icons.file_download),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: lists.length,
    );
  }
}
