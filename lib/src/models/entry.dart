/// Tracking entry.
class Entry {
  /// Creates a new [Entry].
  const Entry({
    required this.timestamp,
  });

  /// Creates a new [Entry] from a json map.
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      timestamp: json['timestamp'] as int,
    );
  }

  /// The creation timestamp in milliseconds since epoch.
  final int timestamp;

  /// Converts the entry to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
    };
  }
}
