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
