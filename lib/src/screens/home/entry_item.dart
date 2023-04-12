import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/widgets/rating_item.dart';

/// A small entry preview item.
class EntryItem extends StatelessWidget {
  /// Creates a new [EntryItem].
  const EntryItem(
    this.entry, {
    this.onTap,
    super.key,
  });

  /// The entry to use.
  final Entry entry;

  /// Handler for when this entry is tapped.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat.yMMMMd().add_jm().format(entry.timestamp);

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        splashColor: entry.rating.color,
        onTap: onTap,
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
