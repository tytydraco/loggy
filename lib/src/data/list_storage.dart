import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:loggy/src/models/loggy_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manage lists.
class ListStorage {
  /// The preference key for the lists.
  static const listsPrefKey = 'lists';

  /// Up-to-date local copy set of lists sorted alphabetically.
  Set<LoggyList> lists = SplayTreeSet((t1, t2) => t1.name.compareTo(t2.name));

  late SharedPreferences _sharedPrefs;
  final _gzipCodec = GZipCodec(level: 9);

  /// Prepare the shared preferences.
  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    lists.addAll(await getAllLists());
  }

  /// Return a set of all stored lists.
  Future<Set<LoggyList>> getAllLists() async {
    final rawListEntries = _sharedPrefs.getStringList(listsPrefKey) ?? [];
    final listEntries = rawListEntries.map((base64) {
      final gzip = _gzipCodec.decode(base64Decode(base64));
      final json = utf8.decode(gzip);
      final listJson = jsonDecode(json) as Map<String, dynamic>;
      return LoggyList.fromJson(listJson);
    });

    return listEntries.toSet();
  }

  /// Sets all stored lists.
  Future<void> setAllLists(Set<LoggyList> newLists) async {
    final rawListEntries = newLists.map((list) {
      final json = jsonEncode(list.toJson());
      final gzip = _gzipCodec.encode(utf8.encode(json));
      return base64Encode(gzip);
    }).toList();

    await _sharedPrefs.setStringList(listsPrefKey, rawListEntries);
  }

  /// Add a list.
  Future<void> addList(LoggyList list) async {
    lists.add(list);

    await setAllLists(lists);
  }

  /// Delete a list.
  Future<void> deleteList(LoggyList list) async {
    lists.remove(list);

    await setAllLists(lists);
  }

  /// Rename a list.
  Future<void> renameList(LoggyList list, String newName) async {
    // Remove the old list from the set.
    await deleteList(list);

    // Add old entries and trackables to the new list.
    final newList = LoggyList(name: newName);
    newList.entries.addAll(list.entries);
    newList.trackables.addAll(list.trackables);

    // Add the renamed list to the set.
    await addList(newList);
  }

  /// Replace a list with a new instance of itself in respect to the list name.
  Future<void> replaceList(LoggyList list) async {
    lists
      ..removeWhere((e) => e.name == list.name)
      ..add(list);

    await setAllLists(lists);
  }
}
