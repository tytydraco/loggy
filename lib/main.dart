import 'package:flutter/material.dart';
import 'package:loggy/src/data/local_storage.dart';
import 'package:loggy/src/data/storage_base.dart';
import 'package:loggy/src/screens/analysis/analysis_screen.dart';
import 'package:loggy/src/screens/home/home_screen.dart';
import 'package:loggy/src/screens/trackables/trackables_screen.dart';
import 'package:provider/provider.dart';

final _storageProvider = LocalStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _storageProvider.init();

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
  final _pageController = PageController();
  var _currentIndex = 0;

  final _analysisKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const TrackablesScreen(),
      AnalysisScreen(key: _analysisKey),
    ];

    return Provider<StorageBase>.value(
      value: _storageProvider,
      child: MaterialApp(
        title: 'Loggy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: PageView(
            controller: _pageController,
            children: pages,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.mood),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: 'Trackables',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: 'Analysis',
              ),
            ],
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _pageController.jumpToPage(index);
              });
            },
          ),
        ),
      ),
    );
  }
}
