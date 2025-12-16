import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/app_state.dart';
import 'package:rhyme_app/components/appbar.dart';
import 'package:rhyme_app/components/buttons.dart';
import 'package:rhyme_app/components/components.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/models/card_status.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';
import 'package:rhyme_app/pages/practice/practice_session_page.dart';

// Provider to manage TextEditingController lifecycle for card memos
final memoControllerProvider = Provider.autoDispose.family<TextEditingController, String>((ref, cardId) {
  final s = ref.read(appStateProvider);
  final card = s.deck.firstWhere(
    (e) => e.id == cardId,
    orElse: () => throw StateError('Card with id $cardId not found'),
  );
  final controller = TextEditingController(text: card.memo);
  
  // Automatically dispose the controller when the provider is disposed
  ref.onDispose(() {
    controller.dispose();
  });
  
  return controller;
});

class CardDetailScreen extends ConsumerWidget {
  final String cardId;
  const CardDetailScreen({super.key, required this.cardId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(appStateProvider);
    final card = s.deck.firstWhere(
      (e) => e.id == cardId,
      orElse: () => throw StateError('Card with id $cardId not found'),
    );
    final memoCtrl = ref.watch(memoControllerProvider(cardId));

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            AppHeader(
              title: 'カード',
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
                  Text(card.text, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text('${card.reading} • ${card.mora}モーラ', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.75))),
                  const SizedBox(height: 6),
                  Text('rhymeKey: ${card.rhymeKey}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.75))),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, runSpacing: 8, children: card.tags.map((t) => Pill(text: t, selected: true, tint: Theme.of(context).colorScheme.secondary)).toList()),
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
                  Text('状態', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  Wrap(spacing: 8, children: [
                    _statusPill(context, '温存', card.status == CardStatus.stock, () {
                      card.status = CardStatus.stock;
                      ref.read(appStateProvider).updateCard(card);
                    }),
                    _statusPill(context, '使用済み', card.status == CardStatus.used, () {
                      card.status = CardStatus.used;
                      ref.read(appStateProvider).updateCard(card);
                    }),
                    _statusPill(context, 'ボツ', card.status == CardStatus.trash, () {
                      card.status = CardStatus.trash;
                      ref.read(appStateProvider).updateCard(card);
                    }),
                  ]),
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
                  Text('メモ', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 10),
                  TextField(
                    controller: memoCtrl,
                    onChanged: (v) {
                      card.memo = v;
                      ref.read(appStateProvider).updateCard(card);
                    },
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: '使いどころ、関連ワード、次の改善…',
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('この韻で練習', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 6),
                        Text('同じ韻キーで瞬発力を鍛える', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.75))),
                      ]),
                    ),
                    SizedBox(
                      width: 120,
                      child: AccentGradientButton(
                        text: '開始',
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => PracticeSessionScreen(
                              mission: Mission(
                                id: 'from_card',
                                rhymeKey: card.rhymeKey,
                                mora: 3,
                                targetCount: 10,
                                mode: PracticeMode.timeAttack,
                                approxAllowed: true,
                              ),
                            ),
                          ));
                        },
                      ),
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
}

Widget _statusPill(BuildContext context, String label, bool selected, VoidCallback onTap) {
  return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(999), child: Pill(text: label, selected: selected));
}