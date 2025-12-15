import 'package:flutter/material.dart';
import 'package:rhyme_app/components/appbar.dart';
import 'package:rhyme_app/components/buttons.dart';
import 'package:rhyme_app/components/components.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/models/practice_result.dart';
import 'package:rhyme_app/pages/practice/practice_home_page.dart';

class PracticeResultScreen extends StatefulWidget {
  final PracticeResult result;
  const PracticeResultScreen({super.key, required this.result});

  @override
  State<PracticeResultScreen> createState() => _PracticeResultScreenState();
}

class _PracticeResultScreenState extends State<PracticeResultScreen> {
  final goodCtrl = TextEditingController(text: 'テンポが落ちなくなった');
  final nextCtrl = TextEditingController(text: '内部韻を1回入れる');

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            AppHeader(
              title: '結果',
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
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Glass(
                radius: 22,
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('スコア', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ScoreTile(label: '一致度', value: '${r.matchScore}', tint: cs.primary),
                      const SizedBox(width: 10),
                      ScoreTile(label: '密度', value: '${r.density}回', tint: cs.secondary),
                      const SizedBox(width: 10),
                      ScoreTile(label: '新規率', value: '${r.novelty}%', tint: Colors.white),
                    ],
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
                  Text('ふり返り', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  TextField(
                    controller: goodCtrl,
                    decoration: _inputDeco(context, '良かった：'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nextCtrl,
                    decoration: _inputDeco(context, '次は：'),
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
                  Text('保存した韻', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  if (r.saved.isEmpty)
                    Text('保存がありません', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65)))
                  else
                    ...r.saved.take(5).map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: MiniSavedRow(card: c),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AccentGradientButton(
                      text: '次のミッション',
                      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            text: 'デッキを見る',
                            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SecondaryButton(
                            text: 'もう一回',
                            onPressed: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const PracticeHomeScreen()),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.14))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.14))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.7))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}
