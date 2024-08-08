import 'package:flutter/material.dart';
import 'package:loggy/src/data/list_storage.dart';
import 'package:loggy/src/screens/lists/lists_screen.dart';
import 'package:provider/provider.dart';

final _listStorage = ListStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _listStorage.init();

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
    return MaterialApp(
      title: 'Loggy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: Provider.value(
        value: _listStorage,
        child: const ListsScreen(),
      ),
    );
  }
}
