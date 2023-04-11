import 'package:loggy/src/models/entry.dart';

/// Storage source to store entries.
abstract class StorageBase {
  /// Return a list of all stored entries.
  Future<List<Entry>> getAllEntries();

  /// Sets all stored entries.
  Future<void> setAllEntries(List<Entry> entries);

  /// Add a new entry.
  Future<void> addEntry(Entry entry) async {
    final allEntries = await getAllEntries();
    allEntries.add(entry);
    await setAllEntries(allEntries);
  }

  /// Delete an entry.
  Future<void> deleteEntry(Entry entry) async {
    final allEntries = await getAllEntries();
    allEntries.remove(entry);
    await setAllEntries(allEntries);
  }
}
