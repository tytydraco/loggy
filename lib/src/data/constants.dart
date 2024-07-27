import 'package:flutter/material.dart';
import 'package:loggy/src/models/rating.dart';

/// The set of ratings to offer.
final defaultRatingScale = [
  Rating(
    value: 0,
    name: 'Very bad',
    color: Colors.red.shade500,
  ),
  Rating(
    value: 1,
    name: 'Bad',
    color: Colors.orange.shade500,
  ),
  Rating(
    value: 2,
    name: 'Okay',
    color: Colors.yellow.shade500,
  ),
  Rating(
    value: 3,
    name: 'Good',
    color: Colors.lightGreen.shade500,
  ),
  Rating(
    value: 4,
    name: 'Very good',
    color: Colors.green.shade500,
  ),
];
