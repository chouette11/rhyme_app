import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/data/datasources/rhyme_data_source.dart';
import 'package:rhyme_app/models/rhyme_card.dart';

final rhymeRepositoryProvider = Provider<RhymeRepository>((ref) {
  return RhymeRepositoryImpl(InMemoryRhymeDataSource());
});

abstract class RhymeRepository {
  List<RhymeCard> getDeck();
  List<RhymeCard> getRecent();
  void saveCard(RhymeCard card);
  void updateCard(RhymeCard card);
}

class RhymeRepositoryImpl implements RhymeRepository {
  final RhymeDataSource _dataSource;

  RhymeRepositoryImpl(this._dataSource);

  @override
  List<RhymeCard> getDeck() => _dataSource.fetchDeck();

  @override
  List<RhymeCard> getRecent() => _dataSource.fetchRecent();

  @override
  void saveCard(RhymeCard card) => _dataSource.addCard(card);

  @override
  void updateCard(RhymeCard card) => _dataSource.updateCard(card);
}
