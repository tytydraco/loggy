import 'dart:collection';
import 'dart:convert';

import 'package:loggy/src/models/loggy_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manage lists.
class ListStorage {
  /// The preference key for the lists.
  static const listsPrefKey = 'lists';

  /// Up-to-date local copy set of lists sorted alphabetically.
  Set<LoggyList> lists = SplayTreeSet((t1, t2) => t1.name.compareTo(t2.name));

  late SharedPreferences _sharedPrefs;

  /// Prepare the shared preferences.
  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
    lists.addAll(await getAllLists());
  }

  /// Return a set of all stored lists.
  Future<Set<LoggyList>> getAllLists() async {
    final allListsRaw = _sharedPrefs.getStringList(listsPrefKey) ?? [];
    final allLists = allListsRaw.map((e) {
      final json = jsonDecode(e) as Map<String, dynamic>;
      return LoggyList.fromJson(json);
    });

    return allLists.toSet();
  }

  /// Sets all stored lists.
  Future<void> setAllLists(Set<LoggyList> newLists) async {
    final jsonEntries = newLists.map((e) {
      final json = e.toJson();
      return jsonEncode(json);
    }).toList();

    await _sharedPrefs.setStringList(listsPrefKey, jsonEntries);
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

  /// Replace a list with a new instance of itself.
  Future<void> updateList(LoggyList list) async {
    lists
      ..removeWhere((e) => e.name == list.name)
      ..add(list);

    await setAllLists(lists);
  }
}
