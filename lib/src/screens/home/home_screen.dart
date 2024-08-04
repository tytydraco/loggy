import 'package:flutter/material.dart';
import 'package:loggy/src/data/local_storage.dart';
import 'package:loggy/src/screens/analysis/analysis_screen.dart';
import 'package:loggy/src/screens/entries/entries_screen.dart';
import 'package:loggy/src/screens/trackables/trackables_screen.dart';
import 'package:provider/provider.dart';

/// The home screen to manage a list.
class HomeScreen extends StatefulWidget {
  /// Creates a new [HomeScreen].
  const HomeScreen({
    required this.localStorage,
    super.key,
  });

  /// The [LocalStorage] to use for the list.
  final LocalStorage localStorage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  var _currentIndex = 0;

  final _analysisKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final pages = [
      const EntriesScreen(),
      const TrackablesScreen(),
      AnalysisScreen(key: _analysisKey),
    ];

    return Provider<LocalStorage>.value(
      value: widget.localStorage,
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
