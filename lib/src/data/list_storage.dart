import 'dart:collection';

import 'package:loggy/src/data/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manage lists.
class ListStorage {
  /// Up-to-date set of lists sorted alphabetically.
  Set<String> lists = SplayTreeSet((t1, t2) => t1.compareTo(t2));

  /// The shared preferences key for the entries.
  static const listsPrefKey = 'lists';

  late SharedPreferences _sharedPrefs;

  /// Prepare the shared preferences.
  Future<void> init({String? suffix}) async {
    _sharedPrefs = await SharedPreferences.getInstance();
    lists.addAll(await getAllLists());
  }

  /// Return a set of all stored lists.
  Future<Set<String>> getAllLists() async {
    final allLists = _sharedPrefs.getStringList(listsPrefKey) ?? [];

    lists
      ..clear()
      ..addAll(allLists);

    return lists.toSet();
  }

  /// Sets all stored lists.
  Future<void> setAllLists(Set<String> newLists) async {
    lists
      ..clear()
      ..addAll(newLists);

    await _sharedPrefs.setStringList(listsPrefKey, lists.toList());
  }

  /// Add an list.
  Future<void> addList(String list) async {
    final allLists = await getAllLists();
    allLists.add(list);
    await setAllLists(allLists);

    lists.add(list);
  }

  /// Delete an list.
  Future<void> deleteList(String list) async {
    final allLists = await getAllLists();
    allLists.remove(list);
    await setAllLists(allLists);

    // Delete stored entries and trackables.
    await _sharedPrefs.remove('${LocalStorage.entriesPrefKeyPrefix}$list');
    await _sharedPrefs.remove('${LocalStorage.trackablesPrefKeyPrefix}$list');

    lists.remove(list);
  }
}
