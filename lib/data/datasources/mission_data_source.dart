import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';

abstract class MissionDataSource {
  Mission loadTodayMission();
  double loadStrictness();
  double saveStrictness(double value);
  void saveMission(Mission mission);
}

class InMemoryMissionDataSource implements MissionDataSource {
  Mission _today = const Mission(
    id: 'm1',
    rhymeKey: '-ou',
    mora: 3,
    targetCount: 10,
    mode: PracticeMode.timeAttack,
    approxAllowed: true,
  );

  double _strictness = 0.65;

  @override
  Mission loadTodayMission() => _today;

  @override
  double loadStrictness() => _strictness;

  @override
  double saveStrictness(double value) {
    _strictness = value.clamp(0.0, 1.0);
    return _strictness;
  }

  @override
  void saveMission(Mission mission) => _today = mission;
}
