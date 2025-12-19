import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rhyme_app/models/mission.dart';
import 'package:rhyme_app/models/practice_mode.dart';

abstract class MissionDataSource {
  Future<Mission> loadTodayMission();
  Future<double> loadStrictness();
  Future<double> saveStrictness(double value);
  Future<void> saveMission(Mission mission);
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
  Future<Mission> loadTodayMission() async => _today;

  @override
  Future<double> loadStrictness() async => _strictness;

  @override
  Future<double> saveStrictness(double value) async {
    _strictness = value.clamp(0.0, 1.0);
    return _strictness;
  }

  @override
  Future<void> saveMission(Mission mission) async => _today = mission;
}

class FirestoreMissionDataSource implements MissionDataSource {
  FirestoreMissionDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _missionDoc =>
      _firestore.collection('missions').doc('today');

  DocumentReference<Map<String, dynamic>> get _settingsDoc =>
      _firestore.collection('settings').doc('app');

  @override
  Future<Mission> loadTodayMission() async {
    final snapshot = await _missionDoc.get();
    final data = snapshot.data();
    if (data == null) {
      return Mission.defaultMission;
    }
    return Mission.fromMap(id: snapshot.id, data: data);
  }

  @override
  Future<double> loadStrictness() async {
    final snapshot = await _settingsDoc.get();
    final value = snapshot.data()?['strictness'];
    if (value is num) {
      return value.toDouble().clamp(0.0, 1.0);
    }
    return 0.65;
  }

  @override
  Future<double> saveStrictness(double value) async {
    final clamped = value.clamp(0.0, 1.0);
    await _settingsDoc.set({'strictness': clamped}, SetOptions(merge: true));
    return clamped;
  }

  @override
  Future<void> saveMission(Mission mission) async {
    await _missionDoc.set(mission.toMap(), SetOptions(merge: true));
  }
}
