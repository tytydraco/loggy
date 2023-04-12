import 'dart:convert';

import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A local implementation of [StorageBase] using shared preferences.
class LocalStorage extends StorageBase {
  /// The shared preferences key.
  static const prefKey = 'entries';

  late SharedPreferences _sharedPrefs;

  /// Prepare the shared preferences.
  @override
  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    entries.addAll(await getAllEntries());
  }

  @override
  Future<Set<Entry>> getAllEntries() async {
    final allEntriesRaw = _sharedPrefs.getStringList(prefKey) ?? [];
    final allEntries = allEntriesRaw.map((e) {
      final json = jsonDecode(e) as Map<String, dynamic>;
      return Entry.fromJson(json);
    }).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return allEntries.toSet();
  }

  @override
  Future<void> setAllEntries(Set<Entry> entries) async {
    entries.toList().sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final jsonEntries = entries.map((e) {
      final json = e.toJson();
      return jsonEncode(json);
    }).toList();

    await _sharedPrefs.setStringList(prefKey, jsonEntries);
  }
}
