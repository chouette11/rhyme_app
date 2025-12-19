import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rhyme_app/app_state.dart';
import 'package:rhyme_app/components/appbar.dart';
import 'package:rhyme_app/components/buttons.dart';
import 'package:rhyme_app/components/components.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/routes.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStateProvider);
    final m = s.today;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          AppHeader(
            title: '今日',
            right: InkWell(
              onTap: () => context.pushNamed(AppRoute.settings),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: const Icon(Icons.settings, size: 18),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Glass(
              radius: 22,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('今日のミッション', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text('“踏める感覚”を積み上げる', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.75))),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Pill(text: m.rhymeKey, selected: true),
                      Pill(text: '${m.mora}モーラ'),
                      Pill(text: m.approxAllowed ? '近似あり' : '厳密のみ'),
                      Pill(text: '×${m.targetCount}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('厳密度', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65))),
                  Slider(
                    value: s.strictness,
                    onChanged: (value) {
                      ref.read(appStateProvider).setStrictness(value).catchError((e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('設定の保存に失敗しました: ${e.toString()}')),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 6),
                  AccentGradientButton(
                    text: '開始',
                    onPressed: () {
                      context.pushNamed(AppRoute.practiceSession, extra: m);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Glass(
              radius: 20,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('進捗', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text('達成 6/${m.targetCount} • 残り 01:20（ダミー）',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.75))),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: 0.6,
                      backgroundColor: Colors.white.withOpacity(0.10),
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Glass(
              radius: 20,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('直近の保存', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  if (s.recentSaved.isEmpty)
                    Text('まだ保存がありません',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65)))
                  else
                    ...s.recentSaved.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: MiniSavedRow(card: c),
                        )),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Glass(
              radius: 20,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('次の一手', style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 6),
                      Text('内部韻 ×1 / 8行（例）', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.75))),
                    ]),
                  ),
                  SizedBox(
                    width: 110,
                    child: SecondaryButton(
                      text: '採用',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('次ミッション（例）を採用しました')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
