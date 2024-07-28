import 'package:flutter/material.dart';
import 'package:loggy/src/models/rating.dart';

/// The set of ratings to offer.
final defaultRatingScale = [
  Rating(
    value: 0,
    name: '-2',
    color: Colors.red.shade500,
  ),
  Rating(
    value: 1,
    name: '-1',
    color: Colors.orange.shade500,
  ),
  Rating(
    value: 2,
    name: '+0',
    color: Colors.yellow.shade500,
  ),
  Rating(
    value: 3,
    name: '+1',
    color: Colors.lightGreen.shade500,
  ),
  Rating(
    value: 4,
    name: '+2',
    color: Colors.green.shade500,
  ),
];
