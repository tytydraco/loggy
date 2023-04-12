import 'package:loggy/src/models/rating.dart';
import 'package:meta/meta.dart';

/// Tracking entry.
@immutable
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

  @override
  bool operator ==(Object other) =>
      other is Entry &&
      other.runtimeType == runtimeType &&
      other.timestamp == timestamp;

  @override
  int get hashCode => timestamp.hashCode;
}
