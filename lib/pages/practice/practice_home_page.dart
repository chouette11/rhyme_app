import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/app_state.dart';
import 'package:rhyme_app/components/appbar.dart';
import 'package:rhyme_app/components/buttons.dart';
import 'package:rhyme_app/components/components.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';
import 'package:rhyme_app/pages/practice/practice_session_page.dart';

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
                                ref.read(appStateProvider).setMissionMode(PracticeMode.timeAttack);
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 10),
                            _ModeRow(
                              label: '行末固定',
                              selected: m.mode == PracticeMode.lineEndLock,
                              onTap: () {
                                ref.read(appStateProvider).setMissionMode(PracticeMode.lineEndLock);
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
              onStart: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PracticeSessionScreen(
                  mission: Mission(
                    id: 'ta',
                    rhymeKey: m.rhymeKey,
                    mora: m.mora,
                    targetCount: m.targetCount,
                    mode: PracticeMode.timeAttack,
                    approxAllowed: m.approxAllowed,
                  ),
                ),
              )),
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
              onStart: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PracticeSessionScreen(
                  mission: Mission(
                    id: 'le',
                    rhymeKey: m.rhymeKey,
                    mora: m.mora,
                    targetCount: 8,
                    mode: PracticeMode.lineEndLock,
                    approxAllowed: m.approxAllowed,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
