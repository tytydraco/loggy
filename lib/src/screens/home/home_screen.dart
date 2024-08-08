import 'package:flutter/material.dart';
import 'package:loggy/src/screens/analysis/analysis_screen.dart';
import 'package:loggy/src/screens/entries/entries_screen.dart';
import 'package:loggy/src/screens/trackables/trackables_screen.dart';

/// The home screen to manage a list.
class HomeScreen extends StatefulWidget {
  /// Creates a new [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  var _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const EntriesScreen(),
      const TrackablesScreen(),
      const AnalysisScreen(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: pages,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
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
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
