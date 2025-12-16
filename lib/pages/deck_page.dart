import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/app_state.dart';
import 'package:rhyme_app/components/appbar.dart';
import 'package:rhyme_app/components/components.dart';
import 'package:rhyme_app/components/glass.dart';
import 'package:rhyme_app/models/card_status.dart';
import 'package:rhyme_app/pages/card_detail_page.dart';
import 'package:rhyme_app/pages/setting_page.dart';

class DeckScreen extends ConsumerStatefulWidget {
  const DeckScreen({super.key});

  @override
  ConsumerState<DeckScreen> createState() => _DeckScreenState();
}

class _DeckScreenState extends ConsumerState<DeckScreen> {
  final TextEditingController search = TextEditingController();
  CardStatus? statusFilter = CardStatus.stock;

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(appStateProvider);

    final query = search.text.trim();
    final cards = s.deck.where((c) {
      final okQuery = query.isEmpty ||
          c.text.contains(query) ||
          c.reading.contains(query) ||
          c.tags.any((t) => t.contains(query)) ||
          c.memo.contains(query);
      final okStatus = statusFilter == null ? true : c.status == statusFilter;
      return okQuery && okStatus;
    }).toList();

    return SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 140),
            children: [
              AppHeader(
                title: 'デッキ',
                right: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
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
                  radius: 18,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: search,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '検索（単語 / 読み / タグ / メモ）',
                          ),
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
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      InkWell(
                        onTap: () => setState(() => statusFilter = CardStatus.stock),
                        child: Pill(text: '温存', selected: statusFilter == CardStatus.stock),
                      ),
                      InkWell(
                        onTap: () => setState(() => statusFilter = CardStatus.used),
                        child: Pill(text: '使用済み', selected: statusFilter == CardStatus.used),
                      ),
                      InkWell(
                        onTap: () => setState(() => statusFilter = CardStatus.trash),
                        child: Pill(text: 'ボツ', selected: statusFilter == CardStatus.trash),
                      ),
                      InkWell(
                        onTap: () => setState(() => statusFilter = null),
                        child: Pill(text: 'All', selected: statusFilter == null, tint: Theme.of(context).colorScheme.secondary),
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
                    Text('最近追加', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65))),
                    const SizedBox(height: 10),
                    if (cards.isEmpty)
                      Text('該当なし', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.65)))
                    else
                      ...cards.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: RhymeCardRow(
                          card: c,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardDetailScreen(cardId: c.id)));
                          },
                        ),
                      )),
                  ]),
                ),
              ),
            ],
          ),

          Positioned(
            right: 18,
            bottom: 120,
            child: InkWell(
              onTap: () => _openAddModal(context),
              borderRadius: BorderRadius.circular(26),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF22D3EE)]),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 10))],
                ),
                child: const Icon(Icons.add, color: Color(0xFF061018), size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddRhymeModal(),
    );
  }
}
