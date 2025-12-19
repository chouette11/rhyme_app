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

  /// Default mission configuration used when no mission data is available
  static const Mission defaultMission = Mission(
    id: 'today',
    rhymeKey: '-ou',
    mora: 3,
    targetCount: 10,
    mode: PracticeMode.timeAttack,
    approxAllowed: true,
  );

  factory Mission.fromMap({required String id, required Map<String, dynamic> data}) {
    return Mission(
      id: id,
      rhymeKey: (data['rhymeKey'] as String?) ?? '',
      mora: (data['mora'] as num?)?.toInt() ?? 0,
      targetCount: (data['targetCount'] as num?)?.toInt() ?? 0,
      mode: PracticeModeX.fromKey(data['mode'] as String?),
      approxAllowed: (data['approxAllowed'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rhymeKey': rhymeKey,
      'mora': mora,
      'targetCount': targetCount,
      'mode': mode.key,
      'approxAllowed': approxAllowed,
    };
  }

  String get title {
    switch (mode) {
      case PracticeMode.timeAttack:
        return 'タイムアタック';
      case PracticeMode.lineEndLock:
        return '行末固定';
    }
  }
}
