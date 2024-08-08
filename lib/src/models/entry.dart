import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:loggy/src/models/rating.dart';

part 'entry.g.dart';

/// Tracking entry.
@immutable
@JsonSerializable()
class Entry {
  /// Creates a new [Entry].
  const Entry({
    required this.timestamp,
    required this.rating,
    this.trackables,
  });

  /// Creates a new [Entry] from a JSON map.
  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  /// The creation timestamp in milliseconds since epoch.
  @_TimestampJsonConverter()
  final DateTime timestamp;

  /// The rating value.
  final Rating rating;

  /// The list of trackables.
  final List<String>? trackables;

  /// Converts the entry to a JSON object.
  Map<String, dynamic> toJson() => _$EntryToJson(this);

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

class _TimestampJsonConverter extends JsonConverter<DateTime, int> {
  const _TimestampJsonConverter();

  @override
  DateTime fromJson(int value) => DateTime.fromMillisecondsSinceEpoch(value);

  @override
  int toJson(DateTime dateTime) => dateTime.millisecondsSinceEpoch;
}
