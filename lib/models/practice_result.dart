import 'package:rhyme_app/models/rhyme_card.dart';

class PracticeResult {
  final int matchScore; // 0-100
  final int density; // count
  final int novelty; // 0-100
  final List<RhymeCard> saved;

  PracticeResult({
    required this.matchScore,
    required this.density,
    required this.novelty,
    required this.saved,
  });
}