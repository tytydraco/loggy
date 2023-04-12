import 'dart:convert';

import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A local implementation of [StorageBase] using shared preferences.
class LocalStorage extends StorageBase {
  /// The shared preferences key for the entries.
  static const entriesPrefKey = 'entries';

  /// The shared preferences key for the trackables.
  static const trackablesPrefKey = 'trackables';

  late SharedPreferences _sharedPrefs;

  /// Prepare the shared preferences.
  @override
  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    entries.addAll(await getAllEntries());
  }

  @override
  Future<Set<Entry>> getAllEntries() async {
    final allEntriesRaw = _sharedPrefs.getStringList(entriesPrefKey) ?? [];
    final allEntries = allEntriesRaw.map((e) {
      final json = jsonDecode(e) as Map<String, dynamic>;
      return Entry.fromJson(json);
    }).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    entries
      ..clear()
      ..addAll(allEntries.toSet());

    return super.getAllEntries();
  }

  @override
  Future<void> setAllEntries(Set<Entry> newEntries) async {
    await super.setAllEntries(newEntries);

    newEntries.toList().sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final jsonEntries = newEntries.map((e) {
      final json = e.toJson();
      return jsonEncode(json);
    }).toList();

    await _sharedPrefs.setStringList(entriesPrefKey, jsonEntries);
  }

  @override
  Future<void> addEntry(Entry entry) async {
    final allEntries = await getAllEntries();
    allEntries.add(entry);
    await setAllEntries(allEntries);

    await super.addEntry(entry);
  }

  @override
  Future<void> deleteEntry(Entry entry) async {
    final allEntries = await getAllEntries();
    allEntries.remove(entry);
    await setAllEntries(allEntries);

    await super.deleteEntry(entry);
  }

  @override
  Future<Set<String>> getAllTrackables() async {
    final allTrackables = _sharedPrefs.getStringList(trackablesPrefKey) ?? [];

    trackables
      ..clear()
      ..addAll(allTrackables.toSet());

    return super.getAllTrackables();
  }

  @override
  Future<void> setAllTrackables(Set<String> newTrackables) async {
    await super.setAllTrackables(newTrackables);

    await _sharedPrefs.setStringList(trackablesPrefKey, newTrackables.toList());
  }

  @override
  Future<void> addTrackable(String trackable) async {
    final allTrackables = await getAllTrackables();
    allTrackables.add(trackable);
    await setAllTrackables(allTrackables);
  }

  @override
  Future<void> deleteTrackable(String trackable) async {
    final allTrackables = await getAllTrackables();
    allTrackables.remove(trackable);
    await setAllTrackables(allTrackables);
  }
}
