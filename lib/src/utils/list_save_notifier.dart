import 'package:flutter/material.dart';

/// A [ChangeNotifier] to notify that the list should be saved to persistent
/// storage.
class ListSaveNotifier with ChangeNotifier {
  /// Tell listeners to save list to storage.
  void save() {
    notifyListeners();
  }
}
