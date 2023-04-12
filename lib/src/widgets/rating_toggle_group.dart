import 'package:flutter/material.dart';
import 'package:loggy/src/models/rating.dart';
import 'package:loggy/src/widgets/rating_item.dart';

/// A single-selectable rating group.
class RatingToggleGroup extends StatefulWidget {
  /// Creates a new [RatingToggleGroup].
  const RatingToggleGroup(
    this.ratings, {
    this.onSelected,
    super.key,
  });

  /// The list of selectable ratings.
  final List<Rating> ratings;

  /// Called when a rating is selected.
  final void Function(int index)? onSelected;

  @override
  State<RatingToggleGroup> createState() => _RatingToggleGroupState();
}

class _RatingToggleGroupState extends State<RatingToggleGroup> {
  int? _selectedIndex;

  Widget _toToggleButtonItem(Rating rating) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: RatingItem(rating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = List.filled(widget.ratings.length, false);
    if (_selectedIndex != null) selected[_selectedIndex!] = true;

    return ToggleButtons(
      isSelected: selected,
      onPressed: (index) {
        widget.onSelected?.call(index);

        setState(() {
          _selectedIndex = index;
        });
      },
      renderBorder: false,
      children: widget.ratings.map(_toToggleButtonItem).toList(),
    );
  }
}
