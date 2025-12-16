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
    today = _missionRepository.getTodayMission();
    strictness = _missionRepository.getStrictness();
    deck = _rhymeRepository.getDeck();
    _recent.addAll(_rhymeRepository.getRecent());
  }

  List<RhymeCard> get recentSaved => List.unmodifiable(_recent.take(3));

  void setStrictness(double v) {
    strictness = _missionRepository.updateStrictness(v.clamp(0, 1));
    notifyListeners();
  }

  void setMissionMode(PracticeMode mode) {
    today = _missionRepository.updateMode(mode);
    notifyListeners();
  }

  void saveToDeck(RhymeCard card) {
    _rhymeRepository.saveCard(card);
    deck = _rhymeRepository.getDeck();
    _refreshRecent();
    notifyListeners();
  }

  void updateCard(RhymeCard updated) {
    _rhymeRepository.updateCard(updated);
    deck = _rhymeRepository.getDeck();
    _refreshRecent();
    notifyListeners();
  }

  void _refreshRecent() {
    _recent
      ..clear()
      ..addAll(_rhymeRepository.getRecent());
  }
}
