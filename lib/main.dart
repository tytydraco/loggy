import 'package:flutter/material.dart';
import 'package:loggy/src/data/local_storage.dart';
import 'package:loggy/src/screens/home/home_screen.dart';

final _localStorage = LocalStorage(suffix: 'all');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _localStorage.init();

  runApp(const Loggy());
}

/// The main application entry point.
class Loggy extends StatefulWidget {
  /// Creates a new [Loggy].
  const Loggy({super.key});

  @override
  State<Loggy> createState() => _LoggyState();
}

class _LoggyState extends State<Loggy> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen(localStorage: _localStorage);
  }
}
