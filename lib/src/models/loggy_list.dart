import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:loggy/src/models/entry.dart';

part 'loggy_list.g.dart';

/// List that keeps track of entries and related data.
@immutable
@JsonSerializable()
class LoggyList {
  /// Creates a new [LoggyList].
  LoggyList({required this.name});

  /// Creates a new [LoggyList] from a JSON map.
  factory LoggyList.fromJson(Map<String, dynamic> json) =>
      _$LoggyListFromJson(json);

  /// The name of the list.
  final String name;

  /// The list entries.
  Set<Entry> get entries => _sortedEntries;

  set entries(Set<Entry> entries) {
    final newSortedEntries = SplayTreeSet<Entry>.from(
      entries,
      (e1, e2) => e2.timestamp.compareTo(e1.timestamp),
    );

    _sortedEntries
      ..clear()
      ..addAll(newSortedEntries);
  }

  /// The list trackables.
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

  final _sortedEntries = SplayTreeSet<Entry>(
    (e1, e2) => e2.timestamp.compareTo(e1.timestamp),
  );

  final _sortedTrackables = SplayTreeSet<String>(
    (e1, e2) => e1.compareTo(e2),
  );

  /// Rename a trackable and update all entries to accommodate.
  void renameTrackable(String oldTrackable, String? newTrackable) {
    // Rename within the trackables set.
    trackables.remove(oldTrackable);
    if (newTrackable != null) trackables.add(newTrackable);

    // Update existing entries for the new renamed trackable.
    final affectedEntries =
        entries.where((e) => e.trackables.contains(oldTrackable)).toSet();

    for (final entry in affectedEntries) {
      final entryRef = entries.lookup(entry);
      if (entryRef == null) return;

      // If a new trackable is specified, add it. Otherwise, keep it deleted.
      entryRef.trackables.remove(oldTrackable);
      if (newTrackable != null) entryRef.trackables.add(newTrackable);
    }
  }

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
