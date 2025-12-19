import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rhyme_app/app_state.dart';
import 'package:rhyme_app/components/appbar.dart';
import 'package:rhyme_app/components/buttons.dart';
import 'package:rhyme_app/components/components.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';
import 'package:rhyme_app/routes.dart';

class PracticeHomeScreen extends ConsumerWidget {
  const PracticeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStateProvider);
    final m = s.today;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          const AppHeader(title: '練習'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Glass(
              radius: 20,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('今日の制約', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65))),
                      const SizedBox(height: 6),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        Pill(text: m.rhymeKey, selected: true),
                        Pill(text: '${m.mora}モーラ'),
                        Pill(text: m.approxAllowed ? '近似あり' : '厳密のみ'),
                      ]),
                    ]),
                  ),
                  SecondaryButton(
                    text: '変更',
                    onPressed: () {
                      // MVP: モードだけ切替。制約変更UIは次フェーズ。
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => Glass(
                          radius: 26,
                          padding: const EdgeInsets.all(16),
                          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('練習モード', style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 12),
                            _ModeRow(
                              label: 'タイムアタック',
                              selected: m.mode == PracticeMode.timeAttack,
                              onTap: () {
                                ref.read(appStateProvider).setMissionMode(PracticeMode.timeAttack).catchError((e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('モードの変更に失敗しました: ${e.toString()}')),
                                  );
                                });
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 10),
                            _ModeRow(
                              label: '行末固定',
                              selected: m.mode == PracticeMode.lineEndLock,
                              onTap: () {
                                ref.read(appStateProvider).setMissionMode(PracticeMode.lineEndLock).catchError((e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('モードの変更に失敗しました: ${e.toString()}')),
                                  );
                                });
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 10),
                          ]),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
          child: PracticeModeCard(
            title: 'タイムアタック',
            desc: '10個保存したら勝ち。反射で韻を出す。',
            badge: '目標：${m.targetCount}個',
            primary: true,
            onStart: () => context.pushNamed(
              AppRoute.practiceSession,
              extra: Mission(
                id: 'ta',
                rhymeKey: m.rhymeKey,
                mora: m.mora,
                targetCount: m.targetCount,
                mode: PracticeMode.timeAttack,
                approxAllowed: m.approxAllowed,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
            child: PracticeModeCard(
            title: '行末固定',
            desc: '行末を決めて、1行ずつ仕上げる。',
            badge: 'パンチライン練習',
            primary: false,
            onStart: () => context.pushNamed(
              AppRoute.practiceSession,
              extra: Mission(
                id: 'le',
                rhymeKey: m.rhymeKey,
                mora: m.mora,
                targetCount: 8,
                mode: PracticeMode.lineEndLock,
                approxAllowed: m.approxAllowed,
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class _ModeRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeRow({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(selected ? 0.10 : 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(selected ? 0.20 : 0.12)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
            if (selected) const Icon(Icons.check_circle, size: 18),
          ],
        ),
      ),
    );
  }
}