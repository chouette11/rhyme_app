import 'package:rhyme_app/models/card_status.dart';

class RhymeCard {
  final String id;
  final String text;
  final String reading;
  final int mora;
  final String rhymeKey;
  final List<String> tags;
  CardStatus status;
  String memo;

  RhymeCard({
    required this.id,
    required this.text,
    required this.reading,
    required this.mora,
    required this.rhymeKey,
    this.tags = const [],
    this.status = CardStatus.stock,
    this.memo = '',
  });
}