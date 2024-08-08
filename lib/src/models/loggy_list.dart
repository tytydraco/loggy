import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:loggy/src/models/entry.dart';

part 'loggy_list.g.dart';

/// List that keeps track of entries and related data.
@immutable
@JsonSerializable()
class LoggyList {
  /// Creates a new [LoggyList].
  const LoggyList({
    required this.name,
    required this.entries,
    required this.trackables,
  });

  /// Creates a new [LoggyList] from a JSON map.
  factory LoggyList.fromJson(Map<String, dynamic> json) =>
      _$LoggyListFromJson(json);

  /// The name of the list.
  final String name;

  /// The list entries.
  final Set<Entry> entries;

  /// The list trackables.
  final Set<String> trackables;

  /// Converts the entry to a JSON object.
  Map<String, dynamic> toJson() => _$LoggyListToJson(this);

  @override
  bool operator ==(Object other) =>
      other is LoggyList &&
      other.runtimeType == runtimeType &&
      other.name == name &&
      setEquals(other.entries, entries) &&
      setEquals(other.trackables, trackables);

  @override
  int get hashCode => Object.hash(name, entries, trackables);
}
