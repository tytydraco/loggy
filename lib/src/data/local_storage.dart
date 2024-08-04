import 'dart:collection';
import 'dart:convert';

import 'package:loggy/src/models/entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage using shared preferences.
class LocalStorage {
  /// The shared preferences key for the entries.
  static const entriesPrefKey = 'entries';

  /// The shared preferences key for the trackables.
  static const trackablesPrefKey = 'trackables';

  /// Up-to-date set of entries sorted by timestamp.
  Set<Entry> entries =
      SplayTreeSet((e1, e2) => e2.timestamp.compareTo(e1.timestamp));

  /// Up-to-date set of trackables sorted alphabetically.
  Set<String> trackables = SplayTreeSet((t1, t2) => t1.compareTo(t2));

  late SharedPreferences _sharedPrefs;

  /// Prepare the shared preferences.
  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  /// Return a set of all stored entries.
  Future<Set<Entry>> getAllEntries() async {
    final allEntriesRaw = _sharedPrefs.getStringList(entriesPrefKey) ?? [];
    final allEntries = allEntriesRaw.map((e) {
      final json = jsonDecode(e) as Map<String, dynamic>;
      return Entry.fromJson(json);
    });

    entries
      ..clear()
      ..addAll(allEntries);

    return entries.toSet();
  }

  /// Sets all stored entries.
  Future<void> setAllEntries(Set<Entry> newEntries) async {
    entries
      ..clear()
      ..addAll(newEntries);

    final jsonEntries = newEntries.map((e) {
      final json = e.toJson();
      return jsonEncode(json);
    }).toList();

    await _sharedPrefs.setStringList(entriesPrefKey, jsonEntries);
  }

  /// Add an entry.
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

  /// Return a set of all stored trackables.
  Future<Set<String>> getAllTrackables() async {
    final allTrackables = _sharedPrefs.getStringList(trackablesPrefKey) ?? [];

    trackables
      ..clear()
      ..addAll(allTrackables.toSet());

    return trackables.toSet();
  }

  /// Sets all stored trackables.
  Future<void> setAllTrackables(Set<String> newTrackables) async {
    trackables
      ..clear()
      ..addAll(newTrackables);

    await _sharedPrefs.setStringList(trackablesPrefKey, newTrackables.toList());
  }

  /// Add a new trackable.
  Future<void> addTrackable(String trackable) async {
    final allTrackables = await getAllTrackables();
    allTrackables.add(trackable);
    await setAllTrackables(allTrackables);
  }

  /// Delete a trackable.
  Future<void> deleteTrackable(String trackable) async {
    final allTrackables = await getAllTrackables();
    allTrackables.remove(trackable);
    await setAllTrackables(allTrackables);
  }
}
