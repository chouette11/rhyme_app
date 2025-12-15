import 'package:flutter/material.dart';
import 'package:rhyme_app/components/buttons.dart';
import 'package:rhyme_app/components/components.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/models/rhyme_card.dart';

class AddRhymeModal extends StatefulWidget {
  const AddRhymeModal({super.key});

  @override
  State<AddRhymeModal> createState() => _AddRhymeModalState();
}

class _AddRhymeModalState extends State<AddRhymeModal> {
  final textCtrl = TextEditingController();
  final List<String> tags = ['街'];

  String get reading => textCtrl.text.trim().isEmpty ? '—' : textCtrl.text.trim();
  int get mora => textCtrl.text.trim().isEmpty ? 0 : (textCtrl.text.trim().length.clamp(1, 6));
  String get rhymeKey => '-ou'; // MVP: ダミー（後で解析に置換）

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Glass(
        radius: 26,
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('追加', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text('単語 / 短いフレーズ', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65))),
          const SizedBox(height: 12),
          TextField(
            controller: textCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: '例：とうきょう',
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.14))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.14))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.7))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          Glass(
            radius: 22,
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('自動解析（MVPは仮）', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Text('reading: $reading', style: Theme.of(context).textTheme.bodySmall),
              Text('mora: $mora', style: Theme.of(context).textTheme.bodySmall),
              Text('rhymeKey: $rhymeKey', style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            ...tags.map((t) => Pill(text: t, selected: true, tint: Theme.of(context).colorScheme.secondary)),
            InkWell(
              onTap: () => setState(() => tags.add('夜')),
              borderRadius: BorderRadius.circular(999),
              child: const Pill(text: '+追加', selected: false),
            ),
          ]),
          const SizedBox(height: 14),
          AccentGradientButton(
            text: '保存する',
            onPressed: () {
              final s = AppScope.of(context);
              final txt = textCtrl.text.trim();
              if (txt.isEmpty) return;

              s.saveToDeck(RhymeCard(
                id: 'manual_${DateTime.now().microsecondsSinceEpoch}',
                text: txt,
                reading: reading,
                mora: mora,
                rhymeKey: rhymeKey,
                tags: List.unmodifiable(tags),
              ));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          SecondaryButton(text: 'キャンセル', onPressed: () => Navigator.pop(context)),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }
}
