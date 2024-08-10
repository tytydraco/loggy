import 'package:flutter/foundation.dart';
import 'package:loggy/src/data/list_storage.dart';
import 'package:loggy/src/models/loggy_list.dart';

/// A class passed to sub-screens with a copy of the [list] for editing and
/// methods to save changes to persistent storage.
class ListInstance with ChangeNotifier {
  /// Creates a new [ListInstance] given a [list].
  ListInstance(this.list, this.listStorage);

  /// The local copy of the list to work with.
  final LoggyList list;

  /// The [ListStorage] instance to work with.
  final ListStorage listStorage;

  /// Update list entry in the database.
  Future<void> save() async {
    if (kDebugMode) print('ListInstance::save called on "${list.name}"');

    // Replace old list with new list.
    await listStorage.replaceList(list);

    notifyListeners();
  }
}
