import 'package:rhyme_app/models/practice_mode.dart';

class Mission {
  final String id;
  final String rhymeKey;
  final int mora;
  final int targetCount;
  final PracticeMode mode;
  final bool approxAllowed;

  const Mission({
    required this.id,
    required this.rhymeKey,
    required this.mora,
    required this.targetCount,
    required this.mode,
    required this.approxAllowed,
  });

  String get title {
    switch (mode) {
      case PracticeMode.timeAttack:
        return 'タイムアタック';
      case PracticeMode.lineEndLock:
        return '行末固定';
    }
  }
}