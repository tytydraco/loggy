import 'dart:collection';

import 'package:loggy/src/models/entry.dart';

/// Storage source to store entries.
abstract class StorageBase {
  /// Up-to-date set of entries sorted by timestamp.
  Set<Entry> entries =
      SplayTreeSet<Entry>((e1, e2) => e2.timestamp.compareTo(e1.timestamp));

  /// Up-to-date set of trackables.
  Set<String> trackables = {};

  /// Perform any necessary setup.
  Future<void> init();

  /// Return a set of all stored entries.
  Future<Set<Entry>> getAllEntries() async {
    return entries.toSet();
  }

  /// Sets all stored entries.
  Future<void> setAllEntries(Set<Entry> newEntries) async {
    entries
      ..clear()
      ..addAll(newEntries);
  }

  /// Add a new entry.
  Future<void> addEntry(Entry entry) async {
    entries.add(entry);
  }

  /// Delete an entry.
  Future<void> deleteEntry(Entry entry) async {
    entries.remove(entry);
  }

  /// Return a set of all stored trackables.
  Future<Set<String>> getAllTrackables() async {
    return trackables.toSet();
  }

  /// Sets all stored trackables.
  Future<void> setAllTrackables(Set<String> newTrackables) async {
    trackables
      ..clear()
      ..addAll(newTrackables);
  }

  /// Add a new trackable.
  Future<void> addTrackable(String trackable) async {
    trackables.add(trackable);
  }

  /// Delete a trackable.
  Future<void> deleteTrackable(String trackable) async {
    trackables.remove(trackable);
  }
}
