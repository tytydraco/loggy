import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loggy/src/data/constants.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:loggy/src/widgets/rating_toggle_group.dart';

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
    final dateString = DateFormat.yMMMMd().format(entry.timestamp);

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Rating.
            RatingToggleGroup(
              defaultRatingScale,
              initialSelection: entry.rating.value,
            ),

            // Date.
            Text(dateString),
          ],
        ),
      ),
    );
  }
}
