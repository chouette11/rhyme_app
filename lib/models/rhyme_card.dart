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

  factory RhymeCard.fromMap({required String id, required Map<String, dynamic> data}) {
    return RhymeCard(
      id: id,
      text: (data['text'] as String?) ?? '',
      reading: (data['reading'] as String?) ?? '',
      mora: (data['mora'] as num?)?.toInt() ?? 0,
      rhymeKey: (data['rhymeKey'] as String?) ?? '',
      tags: (data['tags'] as List<dynamic>?)?.whereType<String>().toList() ?? const [],
      status: CardStatusX.fromKey(data['status'] as String?),
      memo: (data['memo'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'reading': reading,
      'mora': mora,
      'rhymeKey': rhymeKey,
      'tags': tags,
      'status': status.key,
      'memo': memo,
    };
  }
}
