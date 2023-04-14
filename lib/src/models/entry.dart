import 'package:flutter/foundation.dart';
import 'package:loggy/src/models/rating.dart';

/// Tracking entry.
@immutable
class Entry {
  /// Creates a new [Entry].
  const Entry({
    required this.timestamp,
    required this.rating,
    this.trackables,
  });

  /// Creates a new [Entry] from a JSON map.
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      trackables: (json['trackables'] as List<dynamic>?)?.cast<String>(),
    );
  }

  /// The creation timestamp in milliseconds since epoch.
  final DateTime timestamp;

  /// The rating value.
  final Rating rating;

  /// The list of trackables.
  final List<String>? trackables;

  /// Converts the entry to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'rating': rating,
      'trackables': trackables,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is Entry &&
      other.runtimeType == runtimeType &&
      other.timestamp == timestamp &&
      other.rating == rating &&
      listEquals(other.trackables, trackables);

  @override
  int get hashCode => Object.hash(timestamp, rating, trackables);
}
