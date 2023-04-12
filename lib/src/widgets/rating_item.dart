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
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: rating.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          rating.value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
