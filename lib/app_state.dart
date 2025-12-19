import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';
import 'package:rhyme_app/models/rhyme_card.dart';
import 'package:rhyme_app/repositories/mission_repository.dart';
import 'package:rhyme_app/repositories/rhyme_repository.dart';

final appStateProvider = ChangeNotifierProvider<AppState>((ref) => AppState(ref));

class AppState extends ChangeNotifier {
  final MissionRepository _missionRepository;
  final RhymeRepository _rhymeRepository;

  late Mission today;
  late double strictness;
  late List<RhymeCard> deck;
  final List<RhymeCard> _recent = [];

  AppState(Ref ref)
      : _missionRepository = ref.read(missionRepositoryProvider),
        _rhymeRepository = ref.read(rhymeRepositoryProvider) {
    today = const Mission(
      id: 'today',
      rhymeKey: '-ou',
      mora: 3,
      targetCount: 10,
      mode: PracticeMode.timeAttack,
      approxAllowed: true,
    );
    strictness = 0.65;
    deck = const [];
    _initialize();
  }

  List<RhymeCard> get recentSaved => List.unmodifiable(_recent.take(3));

  Future<void> _initialize() async {
    today = await _missionRepository.getTodayMission();
    strictness = await _missionRepository.getStrictness();
    deck = await _rhymeRepository.getDeck();
    _recent
      ..clear()
      ..addAll(await _rhymeRepository.getRecent());
    notifyListeners();
  }

  Future<void> setStrictness(double v) async {
    strictness = await _missionRepository.updateStrictness(v);
    notifyListeners();
  }

  Future<void> setMissionMode(PracticeMode mode) async {
    today = await _missionRepository.updateMode(mode);
    notifyListeners();
  }

  Future<void> saveToDeck(RhymeCard card) async {
    await _rhymeRepository.saveCard(card);
    deck = [card, ...deck];
    await _refreshRecent();
    notifyListeners();
  }

  Future<void> updateCard(RhymeCard updated) async {
    await _rhymeRepository.updateCard(updated);
    final index = deck.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      final updatedDeck = List<RhymeCard>.from(deck);
      updatedDeck[index] = updated;
      deck = updatedDeck;
    } else {
      // Card not in local deck, refresh from repository to maintain consistency
      deck = await _rhymeRepository.getDeck();
    }
    await _refreshRecent();
    notifyListeners();
  }

  Future<void> _refreshRecent() async {
    _recent
      ..clear()
      ..addAll(await _rhymeRepository.getRecent());
  }
}
