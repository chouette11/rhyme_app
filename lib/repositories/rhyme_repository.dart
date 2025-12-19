import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/data/datasources/rhyme_data_source.dart';
import 'package:rhyme_app/data/firebase_config.dart';
import 'package:rhyme_app/models/rhyme_card.dart';

final inMemoryRhymeDataSourceProvider = Provider<InMemoryRhymeDataSource>((ref) {
  return InMemoryRhymeDataSource();
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Provides the [RhymeRepository] implementation with compile-time data source selection.
///
/// **Important: Compile-time Toggle Behavior**
///
/// The data source (in-memory vs. Firestore) is determined at compile-time using the
/// `USE_FIRESTORE` environment variable and cannot be changed at runtime. This means:
///
/// - **Hot-reload will NOT switch between implementations** - The provider reads the
///   `useFirestore` constant at provider build time during app initialization.
/// - **A full app restart is required** to switch between in-memory and Firestore modes.
/// - **To enable Firestore**, compile with: `flutter run --dart-define=USE_FIRESTORE=true`
/// - **To use in-memory storage** (default), compile without the flag or set it to false.
///
/// **Why Compile-time?**
///
/// This design provides:
/// - Zero runtime overhead for data source selection
/// - Predictable behavior during development and production
/// - Simpler dependency management (Firestore can be tree-shaken if unused)
///
/// **Future Consideration:**
///
/// If runtime switching between data sources becomes necessary (e.g., for testing,
/// user preferences, or offline/online mode switching), this provider would need to
/// be refactored to use a state-based provider pattern (e.g., StateProvider or
/// StateNotifierProvider) that can notify listeners when the data source changes.
final rhymeRepositoryProvider = Provider<RhymeRepository>((ref) {
  final dataSource = useFirestore
      ? FirestoreRhymeDataSource(ref.read(firestoreProvider))
      : ref.read(inMemoryRhymeDataSourceProvider);
  return RhymeRepositoryImpl(dataSource);
});

abstract class RhymeRepository {
  Future<List<RhymeCard>> getDeck();
  Future<List<RhymeCard>> getRecent();
  Future<void> saveCard(RhymeCard card);
  Future<void> updateCard(RhymeCard card);
}

class RhymeRepositoryImpl implements RhymeRepository {
  final RhymeDataSource _dataSource;

  RhymeRepositoryImpl(this._dataSource);

  @override
  Future<List<RhymeCard>> getDeck() => _dataSource.fetchDeck();

  @override
  Future<List<RhymeCard>> getRecent() => _dataSource.fetchRecent();

  @override
  Future<void> saveCard(RhymeCard card) => _dataSource.addCard(card);

  @override
  Future<void> updateCard(RhymeCard card) => _dataSource.updateCard(card);
}
