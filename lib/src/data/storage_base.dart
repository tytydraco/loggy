import 'package:loggy/src/models/entry.dart';

/// Storage source to store entries.
abstract class StorageBase {
  /// Return a list of all stored entries.
  Future<List<Entry>> getAllEntries();

  /// Add a new entry.
  Future<void> addEntry(Entry entry);

  /// Delete an entry.
  Future<void> deleteEntry(Entry entry);
}
