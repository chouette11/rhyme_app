import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/data/datasources/mission_data_source.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepositoryImpl(InMemoryMissionDataSource());
});

abstract class MissionRepository {
  Mission getTodayMission();
  Mission updateMode(PracticeMode mode);
  double getStrictness();
  double updateStrictness(double value);
}

class MissionRepositoryImpl implements MissionRepository {
  final MissionDataSource _dataSource;

  MissionRepositoryImpl(this._dataSource);

  @override
  Mission getTodayMission() => _dataSource.loadTodayMission();

  @override
  Mission updateMode(PracticeMode mode) {
    final current = _dataSource.loadTodayMission();
    final updated = Mission(
      id: current.id,
      rhymeKey: current.rhymeKey,
      mora: current.mora,
      targetCount: current.targetCount,
      mode: mode,
      approxAllowed: current.approxAllowed,
    );
    _dataSource.saveMission(updated);
    return updated;
  }

  @override
  double getStrictness() => _dataSource.loadStrictness();

  @override
  double updateStrictness(double value) {
    final clamped = value.clamp(0.0, 1.0);
    _dataSource.saveStrictness(clamped);
    return clamped;
  }
}
