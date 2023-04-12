import 'package:flutter/material.dart';
import 'package:loggy/src/models/rating.dart';
import 'package:loggy/src/widgets/rating_item.dart';

/// A single-selectable rating group.
class RatingToggleGroup extends StatefulWidget {
  /// Creates a new [RatingToggleGroup].
  const RatingToggleGroup(
    this.ratings, {
    this.initialSelection,
    this.onSelected,
    super.key,
  });

  /// The list of selectable ratings.
  final List<Rating> ratings;

  /// The initially selected rating index.
  final int? initialSelection;

  /// Called when a rating is selected.
  final void Function(int index)? onSelected;

  @override
  State<RatingToggleGroup> createState() => _RatingToggleGroupState();
}

class _RatingToggleGroupState extends State<RatingToggleGroup> {
  late var _selectedIndex = widget.initialSelection;

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
        if (widget.onSelected == null) return;

        widget.onSelected?.call(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      borderWidth: 2,
      borderColor: Colors.transparent,
      selectedBorderColor: Colors.blue,
      children: widget.ratings.map(_toToggleButtonItem).toList(),
    );
  }
}
