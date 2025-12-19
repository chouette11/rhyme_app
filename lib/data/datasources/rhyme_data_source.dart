import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhyme_app/models/card_status.dart';
import 'package:rhyme_app/models/rhyme_card.dart';

abstract class RhymeDataSource {
  Future<List<RhymeCard>> fetchDeck();
  Future<List<RhymeCard>> fetchRecent();
  Future<void> addCard(RhymeCard card);
  Future<void> updateCard(RhymeCard card);
}

class InMemoryRhymeDataSource implements RhymeDataSource {
  final List<RhymeCard> _deck = [
    RhymeCard(id: 'c1', text: '東京', reading: 'とうきょう', mora: 4, rhymeKey: '-ou', tags: const ['街', '夜']),
    RhymeCard(id: 'c2', text: '状況', reading: 'じょうきょう', mora: 4, rhymeKey: '-ou', tags: const ['バトル'], status: CardStatus.used),
    RhymeCard(id: 'c3', text: '強行', reading: 'きょうこう', mora: 4, rhymeKey: '-ou', tags: const ['攻']),
  ];

  final List<RhymeCard> _recent = [];

  @override
  Future<List<RhymeCard>> fetchDeck() async => List.unmodifiable(_deck);

  @override
  Future<List<RhymeCard>> fetchRecent() async => List.unmodifiable(_recent.take(20));

  @override
  Future<void> addCard(RhymeCard card) async {
    _deck.insert(0, card);
    _recent.insert(0, card);
    if (_recent.length > 20) {
      _recent.removeLast();
    }
  }

  @override
  Future<void> updateCard(RhymeCard card) async {
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

class FirestoreRhymeDataSource implements RhymeDataSource {
  FirestoreRhymeDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('rhyme_cards');

  @override
  Future<List<RhymeCard>> fetchDeck() async {
    return _fetchCardsWithIndexHandling(
      _collection.orderBy('createdAt', descending: true),
    );
  }

  @override
  Future<List<RhymeCard>> fetchRecent() async {
    return _fetchCardsWithIndexHandling(
      _collection.orderBy('updatedAt', descending: true).limit(20),
    );
  }

  Future<List<RhymeCard>> _fetchCardsWithIndexHandling(
    Query<Map<String, dynamic>> query,
  ) async {
    try {
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => RhymeCard.fromMap(id: doc.id, data: doc.data()))
          .toList(growable: false);
    } on FirebaseException catch (e) {
      if (e.code == 'failed-precondition') {
        // Likely missing Firestore index for the requested orderBy clause.
        // Returning an empty list allows the app to continue running while
        // the index is being created.
        return const <RhymeCard>[];
      }
      rethrow;
    }
  }
  @override
  Future<void> addCard(RhymeCard card) async {
    final data = {
      ...card.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final docRef = _collection.doc(card.id);
    final existing = await docRef.get();
    if (existing.exists) {
      throw StateError('A rhyme card with id ${card.id} already exists.');
    }
    await docRef.set(data, SetOptions(merge: false));
  }

  @override
  Future<void> updateCard(RhymeCard card) async {
    final data = {
      ...card.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _collection.doc(card.id).set(data, SetOptions(merge: true));
  }
}
