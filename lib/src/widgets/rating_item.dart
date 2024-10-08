import 'package:flutter/material.dart';
import 'package:loggy/src/models/rating.dart';

/// A rating item.
class RatingItem extends StatelessWidget {
  /// Creates a new [RatingItem].
  const RatingItem(
    this.rating, {
    super.key,
  });

  /// The rating.
  final Rating rating;

  @override
  Widget build(BuildContext context) {
    return Text(
      rating.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: rating.color,
      ),
    );
  }
}
