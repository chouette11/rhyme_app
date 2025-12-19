import 'package:flutter_test/flutter_test.dart';
import 'package:rhyme_app/data/datasources/mission_data_source.dart';
import 'package:rhyme_app/repositories/mission_repository.dart';

void main() {
  group('MissionRepositoryImpl', () {
    late MissionRepositoryImpl repository;
    late InMemoryMissionDataSource dataSource;

    setUp(() {
      dataSource = InMemoryMissionDataSource();
      repository = MissionRepositoryImpl(dataSource);
    });

    group('updateStrictness', () {
      test('should return clamped value from data source', () {
        final result = repository.updateStrictness(0.75);
        expect(result, 0.75);
        expect(repository.getStrictness(), 0.75);
      });

      test('should handle out-of-range values via data source clamping', () {
        var result = repository.updateStrictness(1.5);
        expect(result, 1.0);
        expect(repository.getStrictness(), 1.0);

        result = repository.updateStrictness(-0.5);
        expect(result, 0.0);
        expect(repository.getStrictness(), 0.0);
      });

      test('should not need to call getStrictness after update', () {
        // This test verifies that updateStrictness returns the correct value
        // without needing an additional call to getStrictness
        final returnedValue = repository.updateStrictness(0.85);
        final loadedValue = repository.getStrictness();
        
        expect(returnedValue, loadedValue);
        expect(returnedValue, 0.85);
      });
    });
  });
}
