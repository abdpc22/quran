import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/quran_screen.dart';
import 'screens/prayer_screen.dart';
import 'screens/qibla_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Home is the only screen initialized at launch.
  final Set<int> _initializedTabs = {0};

  void _selectTab(int index) {
    if (index < 0 || index > 3) return;

    setState(() {
      _selectedIndex = index;
      _initializedTabs.add(index);
    });
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return HomeScreen(onNavigate: _selectTab);

      case 1:
        return const QuranScreen();

      case 2:
        return const PrayerScreen();

      case 3:
        return QiblaScreen(
          isActive: _selectedIndex == 3,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = List<Widget>.generate(4, (index) {
      if (!_initializedTabs.contains(index)) {
        return const SizedBox.shrink();
      }

      return _buildScreen(index);
    });

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectTab,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Prayer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Qibla',
          ),
        ],
      ),
    );
  }
}