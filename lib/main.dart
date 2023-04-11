import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loggy/firebase_options.dart';
import 'package:loggy/src/screens/home/home_screen.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: const HomeScreen(),
    );
  }
}
