import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loggy/src/models/entry.dart';

/// A small entry preview item.
class EntryItem extends StatelessWidget {
  /// Creates a new [EntryItem].
  const EntryItem(
    this.entry, {
    super.key,
  });

  /// The entry to use.
  final Entry entry;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMicrosecondsSinceEpoch(entry.timestamp);
    final dateString = DateFormat.yMMMMd(date).format(date);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Rating.
            const Text('todo'),

            // Date.
            Text(dateString),
          ],
        ),
      ),
    );
  }
}
