import 'package:flutter/material.dart';
import 'package:loggy/src/models/rating.dart';

/// The set of ratings to offer.
const defaultRatingScale = [
  Rating(
    value: 0,
    name: 'Very bad',
    color: Colors.red,
  ),
  Rating(
    value: 1,
    name: 'Bad',
    color: Colors.orange,
  ),
  Rating(
    value: 2,
    name: 'Okay',
    color: Colors.yellow,
  ),
  Rating(
    value: 3,
    name: 'Good',
    color: Colors.lightGreen,
  ),
  Rating(
    value: 4,
    name: 'Very good',
    color: Colors.green,
  ),
];
