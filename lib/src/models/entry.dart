import 'package:loggy/src/models/rating.dart';

/// Tracking entry.
class Entry {
  /// Creates a new [Entry].
  const Entry({
    required this.timestamp,
    required this.rating,
  });

  /// Creates a new [Entry] from a JSON map.
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
    );
  }

  /// The creation timestamp in milliseconds since epoch.
  final DateTime timestamp;

  /// The rating value.
  final Rating rating;

  /// Converts the entry to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'rating': rating,
    };
  }
}
