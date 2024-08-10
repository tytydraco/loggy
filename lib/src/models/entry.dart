import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:loggy/src/models/rating.dart';

part 'entry.g.dart';

/// Tracking entry.
@immutable
@JsonSerializable()
class Entry {
  /// Creates a new [Entry].
  Entry({
    required this.timestamp,
    required this.rating,
    Set<String>? initialTrackables,
  }) {
    if (initialTrackables != null) trackables.addAll(initialTrackables);
  }

  /// Creates a new [Entry] from a JSON map.
  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  /// The creation timestamp in milliseconds since epoch.
  @_TimestampJsonConverter()
  final DateTime timestamp;

  /// The rating value.
  final Rating rating;

  /// The entry trackables.
  Set<String> get trackables => _sortedTrackables;

  set trackables(Set<String> trackables) {
    final newSortedTrackables = SplayTreeSet<String>.from(
      trackables,
      (e1, e2) => e1.compareTo(e2),
    );

    _sortedTrackables
      ..clear()
      ..addAll(newSortedTrackables);
  }

  final _sortedTrackables = SplayTreeSet<String>(
    (e1, e2) => e1.compareTo(e2),
  );

  /// Converts the entry to a JSON object.
  Map<String, dynamic> toJson() => _$EntryToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Entry &&
      other.runtimeType == runtimeType &&
      other.timestamp == timestamp &&
      other.rating == rating &&
      setEquals(other.trackables, trackables);

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
