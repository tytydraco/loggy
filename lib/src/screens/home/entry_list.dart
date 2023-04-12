import 'package:flutter/material.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/screens/home/entry_item.dart';

/// Vertical list of entry items.
class EntryList extends StatelessWidget {
  /// Creates a new [EntryList].
  const EntryList({
    required this.entries,
    super.key,
  });

  /// List of entries.
  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, index) {
        final entry = entries[index];
        return EntryItem(
          entry,
          onTap: () {
            // TODO(tytydraco): launch edit screen
          },
        );
      },
    );
  }
}
