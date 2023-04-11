import 'dart:convert';

import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/exceptions/initialization_exception.dart';
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

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw InitializationException('Must call init() first.');
    }
  }

  @override
  Future<List<Entry>> getAllEntries() async {
    _ensureInitialized();

    final allEntriesRaw = _sharedPrefs.getStringList(prefKey) ?? [];
    return allEntriesRaw.map((e) {
      final json = jsonDecode(e) as Map<String, dynamic>;
      return Entry.fromJson(json);
    }).toList();
  }

  @override
  Future<void> setAllEntries(List<Entry> entries) async {
    _ensureInitialized();

    final jsonEntries = entries.map((e) {
      final json = e.toJson();
      return jsonEncode(json);
    }).toList();
    await _sharedPrefs.setStringList(prefKey, jsonEntries);
  }
}
