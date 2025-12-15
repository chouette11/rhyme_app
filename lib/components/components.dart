import 'package:flutter/material.dart';
import 'package:rhyme_app/components/buttons.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/models/card_status.dart';
import 'package:rhyme_app/models/rhyme_card.dart';

class Pill extends StatelessWidget {
  final String text;
  final bool selected;
  final Color? tint;
  const Pill({super.key, required this.text, this.selected = false, this.tint});

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? (tint ?? Theme.of(context).colorScheme.primary).withOpacity(0.22)
        : Colors.white.withOpacity(0.08);
    final bd = selected
        ? (tint ?? Theme.of(context).colorScheme.primary).withOpacity(0.55)
        : Colors.white.withOpacity(0.14);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: bd),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class ScoreTile extends StatelessWidget {
  final String label;
  final String value;
  final Color tint;

  const ScoreTile({super.key, required this.label, required this.value, required this.tint});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tint.withOpacity(0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tint.withOpacity(0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

/* =========================
   Screens: Today
========================= */

class MiniSavedRow extends StatelessWidget {
  final RhymeCard card;
  const MiniSavedRow({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('${card.text}  •  ${card.reading}', style: Theme.of(context).textTheme.bodyMedium),
          ),
          Pill(text: card.rhymeKey, selected: true),
        ],
      ),
    );
  }
}

/* =========================
   Screens: Practice Home
========================= */


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

class PracticeModeCard extends StatelessWidget {
  final String title;
  final String desc;
  final String badge;
  final bool primary;
  final VoidCallback onStart;

  const PracticeModeCard({
    super.key,
    required this.title,
    required this.desc,
    required this.badge,
    required this.primary,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Glass(
      radius: 22,
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        Text(desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.75))),
        const SizedBox(height: 12),
        Row(
          children: [
            Pill(text: badge, selected: primary, tint: Theme.of(context).colorScheme.secondary),
            const Spacer(),
            SizedBox(
              width: 110,
              child: primary
                  ? AccentGradientButton(text: '開始', onPressed: onStart)
                  : SecondaryButton(text: '開始', onPressed: onStart),
            ),
          ],
        ),
      ]),
    );
  }
}

/* =========================
   Screens: Practice Session
========================= */



class CandidateRow extends StatelessWidget {
  final RhymeCard card;
  final VoidCallback onTap;

  const CandidateRow({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final badgeColor = Theme.of(context).colorScheme.secondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(card.text, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text('${card.reading} • ${card.mora}モーラ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65))),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.16),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: badgeColor.withOpacity(0.35)),
              ),
              child: const Text('◎', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   Screens: Practice Result
========================= */


/* =========================
   Screens: Deck
========================= */


class RhymeCardRow extends StatelessWidget {
  final RhymeCard card;
  final VoidCallback onTap;

  const RhymeCardRow({super.key, required this.card, required this.onTap});

  String get statusText {
    switch (card.status) {
      case CardStatus.stock:
        return '温存';
      case CardStatus.used:
        return '使用';
      case CardStatus.trash:
        return 'ボツ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tint = card.status == CardStatus.stock
        ? Theme.of(context).colorScheme.primary
        : (card.status == CardStatus.used ? Theme.of(context).colorScheme.secondary : Colors.redAccent);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(child: Text(card.text, style: Theme.of(context).textTheme.titleSmall)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: tint.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: tint.withOpacity(0.35)),
                ),
                child: Text(statusText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('${card.reading} • ${card.mora}モーラ • ${card.rhymeKey}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: card.tags.map((t) => Pill(text: t, selected: true, tint: Theme.of(context).colorScheme.secondary)).toList(),
          ),
        ]),
      ),
    );
  }
}
