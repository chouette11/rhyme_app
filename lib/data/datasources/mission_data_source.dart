import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';

abstract class MissionDataSource {
  Mission loadTodayMission();
  double loadStrictness();
  void saveStrictness(double value);
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
  void saveStrictness(double value) => _strictness = value.clamp(0, 1);

  @override
  void saveMission(Mission mission) => _today = mission;
}
