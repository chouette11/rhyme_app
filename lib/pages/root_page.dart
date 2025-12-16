import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_result.dart';
import 'package:rhyme_app/pages/card_detail_page.dart';
import 'package:rhyme_app/pages/deck_page.dart';
import 'package:rhyme_app/pages/practice/practice_home_page.dart';
import 'package:rhyme_app/pages/practice/practice_result_page.dart';
import 'package:rhyme_app/pages/practice/practice_session_page.dart';
import 'package:rhyme_app/pages/setting_page.dart';
import 'package:rhyme_app/pages/today_page.dart';
import 'package:rhyme_app/routes.dart';

final _router = GoRouter(
  initialLocation: '/today',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => RootTabs(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${AppRoute.today}',
              name: AppRoute.today,
              builder: (context, state) => const TodayScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${AppRoute.practice}',
              name: AppRoute.practice,
              builder: (context, state) => const PracticeHomeScreen(),
              routes: [
                GoRoute(
                  path: AppRoute.practiceSession,
                  name: AppRoute.practiceSession,
                  builder: (context, state) {
                    final extra = state.extra;
                    if (extra is! Mission) {
                      return const Scaffold(
                        body: Center(child: Text('Invalid or missing mission data')),
                      );
                    }
                    return PracticeSessionScreen(
                      mission: extra,
                    );
                  },
                ),
                GoRoute(
                  path: AppRoute.practiceResult,
                  name: AppRoute.practiceResult,
                  builder: (context, state) {
                    final extra = state.extra;
                    if (extra is PracticeResult) {
                      return PracticeResultScreen(result: extra);
                    } else {
                      // Fallback: show an error message or a placeholder
                      return const Scaffold(
                        body: Center(
                          child: Text('Invalid or missing practice result.'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${AppRoute.deck}',
              name: AppRoute.deck,
              builder: (context, state) => const DeckScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/${AppRoute.settings}',
      name: AppRoute.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/card/:cardId',
      name: AppRoute.cardDetail,
      builder: (context, state) {
        final cardId = state.pathParameters['cardId'];
        if (cardId == null) {
          return const Scaffold(
            body: Center(child: Text('Error: cardId is missing from the route.')),
          );
        }
        return CardDetailScreen(cardId: cardId);
      },
    ),
  ],
);

class RhymeApp extends StatelessWidget {
  const RhymeApp({super.key});

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

    return MaterialApp.router(
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
      routerConfig: _router,
    );
  }
}

/* =========================
   Root Tabs
========================= */

class RootTabs extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RootTabs({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
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
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (v) => navigationShell.goBranch(
                v,
                initialLocation: v == navigationShell.currentIndex,
              ),
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