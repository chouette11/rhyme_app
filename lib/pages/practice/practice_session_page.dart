import 'package:flutter/material.dart';
import 'package:rhyme_app/components/appbar.dart';
import 'package:rhyme_app/components/buttons.dart';
import 'package:rhyme_app/components/components.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';
import 'package:rhyme_app/models/practice_result.dart';
import 'package:rhyme_app/models/rhyme_card.dart';
import 'package:rhyme_app/pages/practice/practice_result_page.dart';

class PracticeSessionScreen extends StatefulWidget {
  final Mission mission;
  const PracticeSessionScreen({super.key, required this.mission});

  @override
  State<PracticeSessionScreen> createState() => _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends State<PracticeSessionScreen> {
  final TextEditingController ctrl = TextEditingController();
  final List<RhymeCard> saved = [];
  int secondsLeft = 80; // ダミー
  String? lockedEnd; // 行末固定モードで使用

  List<RhymeCard> _candidates(String query) {
    // MVP: ダミー候補（後で辞書/検索/生成に置換）
    final base = [
      RhymeCard(id: 'x1', text: '東京', reading: 'とうきょう', mora: 4, rhymeKey: widget.mission.rhymeKey, tags: const ['街']),
      RhymeCard(id: 'x2', text: '状況', reading: 'じょうきょう', mora: 4, rhymeKey: widget.mission.rhymeKey, tags: const ['バトル']),
      RhymeCard(id: 'x3', text: '強行', reading: 'きょうこう', mora: 4, rhymeKey: widget.mission.rhymeKey, tags: const ['攻']),
      RhymeCard(id: 'x4', text: '情報', reading: 'じょうほう', mora: 4, rhymeKey: widget.mission.rhymeKey, tags: const []),
      RhymeCard(id: 'x5', text: '上等', reading: 'じょうとう', mora: 4, rhymeKey: widget.mission.rhymeKey, tags: const []),
    ];

    if (query.trim().isEmpty) return base;
    return base.where((c) => c.text.contains(query) || c.reading.contains(query)).toList();
  }

  void _saveCandidate(RhymeCard c) {
    final s = AppScope.of(context);
    final card = RhymeCard(
      id: 'saved_${DateTime.now().microsecondsSinceEpoch}',
      text: c.text,
      reading: c.reading,
      mora: c.mora,
      rhymeKey: c.rhymeKey,
      tags: c.tags,
    );
    s.saveToDeck(card);
    setState(() {
      saved.insert(0, card);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('デッキに保存しました')));
  }

  void _end() {
    // MVP: ダミースコア
    final result = PracticeResult(
      matchScore: 82,
      density: saved.length,
      novelty: 71,
      saved: List.unmodifiable(saved),
    );
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => PracticeResultScreen(result: result)));
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mission;
    final candidates = _candidates(ctrl.text);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            AppHeader(
              title: m.title,
              left: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: const Icon(Icons.arrow_back, size: 18),
                ),
              ),
              right: InkWell(
                onTap: _end,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.16)),
                  ),
                  child: const Text('終了', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Glass(
                radius: 22,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(spacing: 8, runSpacing: 8, children: [
                        Pill(text: m.rhymeKey, selected: true),
                        Pill(text: '${m.mora}モーラ'),
                        Pill(text: m.approxAllowed ? '近似あり' : '厳密のみ'),
                      ]),
                    ),
                    Pill(text: '${saved.length}/${m.targetCount}', selected: true, tint: Theme.of(context).colorScheme.secondary),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (m.mode == PracticeMode.timeAttack)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Glass(
                  radius: 18,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Text('残り 01:${secondsLeft.toString().padLeft(2, '0')}', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            backgroundColor: Colors.white.withOpacity(0.10),
                            valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
                            minHeight: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 12),

            if (m.mode == PracticeMode.lineEndLock)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Glass(
                  radius: 18,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lockedEnd == null ? '行末が未固定です' : '行末固定：$lockedEnd',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      if (lockedEnd != null)
                        SecondaryButton(
                          text: '解除',
                          onPressed: () => setState(() => lockedEnd = null),
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Glass(
                radius: 22,
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('入力', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ctrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: '単語 / 短フレーズ（例：とうきょう）',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.06),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.14))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.14))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.7))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                  ),
                ]),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Glass(
                radius: 22,
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('候補', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  ...candidates.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CandidateRow(
                      card: c,
                      onTap: () {
                        if (m.mode == PracticeMode.lineEndLock && lockedEnd == null) {
                          setState(() => lockedEnd = c.text);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('行末を固定しました')));
                          return;
                        }
                        _saveCandidate(c);
                      },
                    ),
                  )),
                ]),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Glass(
                radius: 26,
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: AccentGradientButton(
                        text: '保存',
                        onPressed: candidates.isEmpty ? nullSafe : () => _saveCandidate(candidates.first),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 92,
                      child: SecondaryButton(text: '次', onPressed: () => ctrl.clear()),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 92,
                      child: SecondaryButton(text: '修正', onPressed: () {}),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback get nullSafe => () {};
}