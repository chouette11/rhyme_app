import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/data/datasources/mission_data_source.dart';
import 'package:rhyme_app/data/firebase_config.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';

final inMemoryMissionDataSourceProvider = Provider<InMemoryMissionDataSource>((ref) {
  return InMemoryMissionDataSource();
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  final dataSource = useFirestore
      ? FirestoreMissionDataSource(ref.read(firestoreProvider))
      : ref.read(inMemoryMissionDataSourceProvider);
  return MissionRepositoryImpl(dataSource);
});

abstract class MissionRepository {
  Future<Mission> getTodayMission();
  Future<Mission> updateMode(PracticeMode mode);
  Future<double> getStrictness();
  Future<double> updateStrictness(double value);
}

class MissionRepositoryImpl implements MissionRepository {
  final MissionDataSource _dataSource;

  MissionRepositoryImpl(this._dataSource);

  @override
  Future<Mission> getTodayMission() => _dataSource.loadTodayMission();

  @override
  Future<Mission> updateMode(PracticeMode mode) async {
    final current = await _dataSource.loadTodayMission();
    final updated = Mission(
      id: current.id,
      rhymeKey: current.rhymeKey,
      mora: current.mora,
      targetCount: current.targetCount,
      mode: mode,
      approxAllowed: current.approxAllowed,
    );
    await _dataSource.saveMission(updated);
    return updated;
  }

  @override
  Future<double> getStrictness() => _dataSource.loadStrictness();

  @override
  Future<double> updateStrictness(double value) => _dataSource.saveStrictness(value);
}
