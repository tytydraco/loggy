import 'dart:collection';

import 'package:loggy/src/models/entry.dart';

/// Storage source to store entries.
abstract class StorageBase {
  /// Up-to-date list of entries sorted by timestamp.
  Set<Entry> entries =
      SplayTreeSet<Entry>((e1, e2) => e2.timestamp.compareTo(e1.timestamp));

  /// Perform any necessary setup.
  Future<void> init();

  /// Return a list of all stored entries.
  Future<Set<Entry>> getAllEntries() async {
    return entries.toSet();
  }

  /// Sets all stored entries.
  Future<void> setAllEntries(Set<Entry> entries) async {
    entries
      ..clear()
      ..addAll(entries);
  }

  /// Add a new entry.
  Future<void> addEntry(Entry entry) async {
    final allEntries = await getAllEntries();
    allEntries.add(entry);
    await setAllEntries(allEntries);

    entries.add(entry);
  }

  /// Delete an entry.
  Future<void> deleteEntry(Entry entry) async {
    final allEntries = await getAllEntries();
    allEntries.remove(entry);
    await setAllEntries(allEntries);

    entries.remove(entry);
  }
}
