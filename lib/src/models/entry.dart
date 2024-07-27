import 'package:flutter/foundation.dart';
import 'package:loggy/src/models/rating.dart';

/// Tracking entry.
@immutable
class Entry {
  /// Creates a new [Entry].
  const Entry({
    required this.timestamp,
    required this.rating,
    required this.trackable,
  });

  /// Creates a new [Entry] from a JSON map.
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      trackable: json['trackable'] as String,
    );
  }

  /// The creation timestamp in milliseconds since epoch.
  final DateTime timestamp;

  /// The rating value.
  final Rating rating;

  /// The list of trackables.
  final String trackable;

  /// Converts the entry to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'rating': rating,
      'trackable': trackable,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is Entry &&
      other.runtimeType == runtimeType &&
      other.timestamp == timestamp &&
      other.rating == rating &&
      other.trackable == trackable;

  @override
  int get hashCode => Object.hash(timestamp, rating, trackable);
}
