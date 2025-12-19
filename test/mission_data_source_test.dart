import 'package:flutter_test/flutter_test.dart';
import 'package:rhyme_app/data/datasources/mission_data_source.dart';

void main() {
  group('InMemoryMissionDataSource', () {
    late InMemoryMissionDataSource dataSource;

    setUp(() {
      dataSource = InMemoryMissionDataSource();
    });

    group('saveStrictness', () {
      test('should return clamped value when value is within range', () {
        final result = dataSource.saveStrictness(0.5);
        expect(result, 0.5);
        expect(dataSource.loadStrictness(), 0.5);
      });

      test('should clamp and return value when above 1', () {
        final result = dataSource.saveStrictness(1.5);
        expect(result, 1.0);
        expect(dataSource.loadStrictness(), 1.0);
      });

      test('should clamp and return value when below 0', () {
        final result = dataSource.saveStrictness(-0.5);
        expect(result, 0.0);
        expect(dataSource.loadStrictness(), 0.0);
      });

      test('should return exact boundary values', () {
        var result = dataSource.saveStrictness(0.0);
        expect(result, 0.0);
        expect(dataSource.loadStrictness(), 0.0);

        result = dataSource.saveStrictness(1.0);
        expect(result, 1.0);
        expect(dataSource.loadStrictness(), 1.0);
      });
    });
  });
}
