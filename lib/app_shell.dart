import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/search_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/mini_player.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _tabs = [
    (icon: Icons.home_outlined, label: 'Home', active: Icons.home),
    (icon: Icons.search_outlined, label: 'Search', active: Icons.search),
    (icon: Icons.library_music_outlined, label: 'Library', active: Icons.library_music),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          SearchScreen(),
          LibraryScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          BottomNavigationBar(
            backgroundColor: AppTheme.spotifyDarkGray,
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            items: _tabs
                .asMap()
                .entries
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: Icon(_index == e.key ? e.value.active : e.value.icon),
                    label: e.value.label,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
