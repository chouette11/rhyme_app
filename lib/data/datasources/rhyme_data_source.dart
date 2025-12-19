import 'package:rhyme_app/models/card_status.dart';
import 'package:rhyme_app/models/rhyme_card.dart';

abstract class RhymeDataSource {
  List<RhymeCard> fetchDeck();
  List<RhymeCard> fetchRecent();
  void addCard(RhymeCard card);
  void updateCard(RhymeCard card);
}

class InMemoryRhymeDataSource implements RhymeDataSource {
  final List<RhymeCard> _deck = [
    RhymeCard(id: 'c1', text: '東京', reading: 'とうきょう', mora: 4, rhymeKey: '-ou', tags: const ['街', '夜']),
    RhymeCard(id: 'c2', text: '状況', reading: 'じょうきょう', mora: 4, rhymeKey: '-ou', tags: const ['バトル'], status: CardStatus.used),
    RhymeCard(id: 'c3', text: '強行', reading: 'きょうこう', mora: 4, rhymeKey: '-ou', tags: const ['攻']),
  ];

  final List<RhymeCard> _recent = [];

  @override
  List<RhymeCard> fetchDeck() => List.unmodifiable(_deck);

  @override
  List<RhymeCard> fetchRecent() => List.unmodifiable(_recent.take(20));

  @override
  void addCard(RhymeCard card) {
    _deck.insert(0, card);
    _recent.insert(0, card);
    if (_recent.length > 20) {
      _recent.removeLast();
    }
  }

  @override
  void updateCard(RhymeCard card) {
    final index = _deck.indexWhere((c) => c.id == card.id);
    if (index != -1) {
      _deck[index] = card;
    }
    final recentIndex = _recent.indexWhere((c) => c.id == card.id);
    if (recentIndex != -1) {
      _recent[recentIndex] = card;
    }
  }
}
