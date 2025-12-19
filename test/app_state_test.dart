import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rhyme_app/app_state.dart';
import 'package:rhyme_app/data/datasources/mission_data_source.dart';
import 'package:rhyme_app/data/datasources/rhyme_data_source.dart';
import 'package:rhyme_app/models/card_status.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';
import 'package:rhyme_app/models/rhyme_card.dart';
import 'package:rhyme_app/repositories/mission_repository.dart';
import 'package:rhyme_app/repositories/rhyme_repository.dart';

// Mock data sources that throw errors
class FailingMissionDataSource implements MissionDataSource {
  @override
  Future<Mission> loadTodayMission() async {
    throw Exception('Network error');
  }

  @override
  Future<double> loadStrictness() async {
    throw Exception('Network error');
  }

  @override
  Future<Mission> saveMission(Mission mission) async {
    throw Exception('Network error');
  }

  @override
  Future<double> saveStrictness(double value) async {
    throw Exception('Network error');
  }
}

class FailingRhymeDataSource implements RhymeDataSource {
  @override
  Future<void> addCard(RhymeCard card) async {
    throw Exception('Network error');
  }

  @override
  Future<List<RhymeCard>> fetchDeck() async {
    throw Exception('Network error');
  }

  @override
  Future<List<RhymeCard>> fetchRecent() async {
    throw Exception('Network error');
  }

  @override
  Future<void> updateCard(RhymeCard card) async {
    throw Exception('Network error');
  }
}

void main() {
  group('AppState Error Handling', () {
    test('setStrictness should revert on error and rethrow', () async {
      final container = ProviderContainer(
        overrides: [
          missionRepositoryProvider.overrideWithValue(
            MissionRepositoryImpl(FailingMissionDataSource()),
          ),
          rhymeRepositoryProvider.overrideWithValue(
            RhymeRepositoryImpl(InMemoryRhymeDataSource()),
          ),
        ],
      );

      final appState = container.read(appStateProvider);
      final initialStrictness = appState.strictness;

      // Should throw error and revert state
      expect(
        () => appState.setStrictness(0.8),
        throwsA(isA<Exception>()),
      );

      await Future.delayed(const Duration(milliseconds: 10));
      
      // State should be reverted
      expect(appState.strictness, initialStrictness);
      
      container.dispose();
    });

    test('setMissionMode should revert on error and rethrow', () async {
      final container = ProviderContainer(
        overrides: [
          missionRepositoryProvider.overrideWithValue(
            MissionRepositoryImpl(FailingMissionDataSource()),
          ),
          rhymeRepositoryProvider.overrideWithValue(
            RhymeRepositoryImpl(InMemoryRhymeDataSource()),
          ),
        ],
      );

      final appState = container.read(appStateProvider);
      final initialMode = appState.today.mode;

      // Should throw error and revert state
      expect(
        () => appState.setMissionMode(PracticeMode.lineEndLock),
        throwsA(isA<Exception>()),
      );

      await Future.delayed(const Duration(milliseconds: 10));
      
      // State should be reverted
      expect(appState.today.mode, initialMode);
      
      container.dispose();
    });

    test('saveToDeck should not modify state on error and rethrow', () async {
      final container = ProviderContainer(
        overrides: [
          missionRepositoryProvider.overrideWithValue(
            MissionRepositoryImpl(InMemoryMissionDataSource()),
          ),
          rhymeRepositoryProvider.overrideWithValue(
            RhymeRepositoryImpl(FailingRhymeDataSource()),
          ),
        ],
      );

      final appState = container.read(appStateProvider);
      final initialDeckLength = appState.deck.length;

      final testCard = RhymeCard(
        id: 'test_card',
        text: 'テスト',
        reading: 'てすと',
        mora: 3,
        rhymeKey: '-ou',
        tags: const [],
      );

      // Should throw error and not modify deck
      expect(
        () => appState.saveToDeck(testCard),
        throwsA(isA<Exception>()),
      );

      await Future.delayed(const Duration(milliseconds: 10));
      
      // Deck should not be modified
      expect(appState.deck.length, initialDeckLength);
      
      container.dispose();
    });

    test('updateCard should revert on error and rethrow', () async {
      final container = ProviderContainer(
        overrides: [
          missionRepositoryProvider.overrideWithValue(
            MissionRepositoryImpl(InMemoryMissionDataSource()),
          ),
          rhymeRepositoryProvider.overrideWithValue(
            RhymeRepositoryImpl(FailingRhymeDataSource()),
          ),
        ],
      );

      final appState = container.read(appStateProvider);
      final initialDeck = List<RhymeCard>.from(appState.deck);

      if (initialDeck.isNotEmpty) {
        final cardToUpdate = initialDeck.first;
        final updatedCard = RhymeCard(
          id: cardToUpdate.id,
          text: cardToUpdate.text,
          reading: cardToUpdate.reading,
          mora: cardToUpdate.mora,
          rhymeKey: cardToUpdate.rhymeKey,
          tags: cardToUpdate.tags,
          status: CardStatus.used,
        );

        // Should throw error and revert deck
        expect(
          () => appState.updateCard(updatedCard),
          throwsA(isA<Exception>()),
        );

        await Future.delayed(const Duration(milliseconds: 10));
        
        // Deck should be reverted
        expect(appState.deck.length, initialDeck.length);
        expect(appState.deck.first.status, initialDeck.first.status);
      }
      
      container.dispose();
    });
  });
}
