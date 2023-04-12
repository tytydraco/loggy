import 'package:flutter/material.dart';
import 'package:loggy/src/data/local_storage.dart';
import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

final _storageProvider = LocalStorage();

Future<void> main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  await _storageProvider.init();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Loggy());
}

/// The main application entry point.
class Loggy extends StatelessWidget {
  /// Creates a new [Loggy].
  const Loggy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loggy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider<StorageBase>.value(
        value: _storageProvider,
        child: const HomeScreen(),
      ),
    );
  }
}
