import 'package:flutter/material.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/pages/deck_page.dart';
import 'package:rhyme_app/pages/practice/practice_home_page.dart';
import 'package:rhyme_app/pages/today_page.dart';

class RhymeApp extends StatefulWidget {
  const RhymeApp({super.key});
  @override
  State<RhymeApp> createState() => _RhymeAppState();
}

class _RhymeAppState extends State<RhymeApp> {
  final AppState state = AppState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C3AED),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF7C3AED),
      secondary: const Color(0xFF22D3EE),
      surface: const Color(0xFF0B1024),
    );

    return AppScope(
      state: state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF070A12),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        home: const RootTabs(),
      ),
    );
  }
}

/* =========================
   Root Tabs
========================= */

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});
  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    const pages = [
      TodayScreen(),
      PracticeHomeScreen(),
      DeckScreen(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
          child: Glass(
            radius: 26,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: NavigationBar(
              height: 64,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedIndex: index,
              onDestinationSelected: (v) => setState(() => index = v),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.today_outlined), label: '今日'),
                NavigationDestination(icon: Icon(Icons.flash_on_outlined), label: '練習'),
                NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'デッキ'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}