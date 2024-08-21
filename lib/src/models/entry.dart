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
    Map<String, double?>? initialValues,
  }) {
    if (initialValues != null) values.addAll(initialValues);
  }

  /// Creates a new [Entry] from a JSON map.
  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  /// The creation timestamp in milliseconds since epoch.
  @_TimestampJsonConverter()
  final DateTime timestamp;

  /// The rating value.
  final Rating rating;

  /// The entry values.
  Map<String, double?> get values => _sortedValues;

  set values(Map<String, double?> trackables) {
    final newSortedTrackables = SplayTreeMap<String, double?>.from(
      trackables,
      (e1, e2) => e1.compareTo(e2),
    );

    _sortedValues
      ..clear()
      ..addAll(newSortedTrackables);
  }

  final _sortedValues = SplayTreeMap<String, double?>(
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
      mapEquals(other.values, values);

  @override
  int get hashCode => Object.hash(timestamp, rating, values);
}

class _TimestampJsonConverter extends JsonConverter<DateTime, int> {
  const _TimestampJsonConverter();

  @override
  DateTime fromJson(int value) => DateTime.fromMillisecondsSinceEpoch(value);

  @override
  int toJson(DateTime dateTime) => dateTime.millisecondsSinceEpoch;
}
