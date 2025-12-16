import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/models/card_status.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';
import 'package:rhyme_app/models/rhyme_card.dart';

final appStateProvider = ChangeNotifierProvider<AppState>((ref) => AppState());

class AppState extends ChangeNotifier {
  Mission today = const Mission(
    id: 'm1',
    rhymeKey: '-ou',
    mora: 3,
    targetCount: 10,
    mode: PracticeMode.timeAttack,
    approxAllowed: true,
  );

  double strictness = 0.65; // 0:ゆる〜1:ガチ
  final List<RhymeCard> deck = [
    RhymeCard(id: 'c1', text: '東京', reading: 'とうきょう', mora: 4, rhymeKey: '-ou', tags: ['街', '夜']),
    RhymeCard(id: 'c2', text: '状況', reading: 'じょうきょう', mora: 4, rhymeKey: '-ou', tags: ['バトル'], status: CardStatus.used),
    RhymeCard(id: 'c3', text: '強行', reading: 'きょうこう', mora: 4, rhymeKey: '-ou', tags: ['攻']),
  ];

  final List<RhymeCard> _recent = [];

  List<RhymeCard> get recentSaved => List.unmodifiable(_recent.take(3));

  void setStrictness(double v) {
    strictness = v.clamp(0, 1);
    notifyListeners();
  }

  void setMissionMode(PracticeMode mode) {
    today = Mission(
      id: today.id,
      rhymeKey: today.rhymeKey,
      mora: today.mora,
      targetCount: today.targetCount,
      mode: mode,
      approxAllowed: today.approxAllowed,
    );
    notifyListeners();
  }

  void saveToDeck(RhymeCard card) {
    deck.insert(0, card);
    _recent.insert(0, card);
    if (_recent.length > 20) _recent.removeLast();
    notifyListeners();
  }

  void updateCard(RhymeCard updated) {
    final i = deck.indexWhere((e) => e.id == updated.id);
    if (i >= 0) {
      deck[i] = updated;
      notifyListeners();
    }
  }
}
