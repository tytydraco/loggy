import 'dart:convert';

import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/models/entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A local implementation of [StorageBase] using shared preferences.
class LocalStorage extends StorageBase {
  /// The shared preferences key.
  static const prefKey = 'entries';

  late SharedPreferences _sharedPrefs;

  var _isInitialized = false;

  /// Prepare the shared preferences.
  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) await init();
  }

  @override
  Future<List<Entry>> getAllEntries() async {
    await _ensureInitialized();

    final allEntriesRaw = _sharedPrefs.getStringList(prefKey) ?? [];
    return allEntriesRaw.map((e) {
      final json = jsonDecode(e) as Map<String, dynamic>;
      return Entry.fromJson(json);
    }).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  Future<void> setAllEntries(List<Entry> entries) async {
    await _ensureInitialized();

    entries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final jsonEntries = entries.map((e) {
      final json = e.toJson();
      return jsonEncode(json);
    }).toList();

    await _sharedPrefs.setStringList(prefKey, jsonEntries);
  }
}
