import 'dart:developer' as developer;
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
  
  bool isInitializing = true;
  String? initializationError;

  AppState(Ref ref)
      : _missionRepository = ref.read(missionRepositoryProvider),
        _rhymeRepository = ref.read(rhymeRepositoryProvider) {
    today = Mission.defaultMission;
    strictness = 0.65;
    deck = const [];
    _initialize();
  }

  List<RhymeCard> get recentSaved => List.unmodifiable(_recent.take(3));

  Future<void> _initialize() async {
    try {
      today = await _missionRepository.getTodayMission();
      strictness = await _missionRepository.getStrictness();
      deck = await _rhymeRepository.getDeck();
      _recent
        ..clear()
        ..addAll(await _rhymeRepository.getRecent());
      isInitializing = false;
      initializationError = null;
    } catch (e) {
      isInitializing = false;
      initializationError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> setStrictness(double v) async {
    final previousStrictness = strictness;
    try {
      strictness = await _missionRepository.updateStrictness(v);
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Failed to update strictness',
        error: e,
        stackTrace: stackTrace,
        name: 'AppState',
      );
      // Revert local state on error
      strictness = previousStrictness;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> setMissionMode(PracticeMode mode) async {
    final previousMission = today;
    try {
      today = await _missionRepository.updateMode(mode);
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Failed to update mission mode',
        error: e,
        stackTrace: stackTrace,
        name: 'AppState',
      );
      // Revert local state on error
      today = previousMission;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> saveToDeck(RhymeCard card) async {
    try {
      await _rhymeRepository.saveCard(card);
      deck = [card, ...deck];
      await _refreshRecent();
      notifyListeners();
    } catch (e, stackTrace) {
      developer.log(
        'Failed to save card to deck',
        error: e,
        stackTrace: stackTrace,
        name: 'AppState',
      );
      // Do not modify local state on error
      rethrow;
    }
  }

  Future<void> updateCard(RhymeCard updated) async {
    final previousDeck = deck;
    try {
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
    } catch (e, stackTrace) {
      developer.log(
        'Failed to update card',
        error: e,
        stackTrace: stackTrace,
        name: 'AppState',
      );
      // Revert local state on error
      deck = previousDeck;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _refreshRecent() async {
    _recent
      ..clear()
      ..addAll(await _rhymeRepository.getRecent());
  }
}
