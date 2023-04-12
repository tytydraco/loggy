import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/widgets/rating_item.dart';

/// A small entry preview item.
class EntryItem extends StatelessWidget {
  /// Creates a new [EntryItem].
  const EntryItem(
    this.entry, {
    this.onEdit,
    this.onDelete,
    super.key,
  });

  /// The entry to use.
  final Entry entry;

  /// Handler for when this entry is tapped.
  final void Function()? onEdit;

  /// Handler for when this entry is long-pressed.
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('MMMM d, y\nh:m a').format(entry.timestamp);

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        splashColor: entry.rating.color,
        onTap: onEdit,
        onLongPress: onDelete,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date.
              Expanded(
                child: Text(dateString),
              ),

              // Rating.
              RatingItem(entry.rating),
            ],
          ),
        ),
      ),
    );
  }
}
