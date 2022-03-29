import 'package:flutter_test/flutter_test.dart';
import 'package:foodandbody/screens/home/bloc/home_bloc.dart';

void main() {
  const int mockWater = 5;

  group('HomeEvent', () {
    group('IncreaseWaterEvent', () {
      test('supports value equality', () {
        expect(
          IncreaseWaterEvent(),
          equals(IncreaseWaterEvent()),
        );
      });

      test('props are correct', () {
        expect(
          IncreaseWaterEvent().props,
          equals(<Object?>[]),
        );
      });
    });

    group('DecreaseWaterEvent', () {
      test('supports value equality', () {
        expect(
          DecreaseWaterEvent(),
          equals(DecreaseWaterEvent()),
        );
      });

      test('props are correct', () {
        expect(
          DecreaseWaterEvent().props,
          equals(<Object?>[]),
        );
      });
    });

    group('WaterChanged', () {
      test('supports value equality', () {
        expect(
          WaterChanged(water: mockWater),
          equals(
            WaterChanged(water: mockWater),
          ),
        );
      });

      test('props are correct', () {
        expect(
          WaterChanged(water: mockWater).props,
          equals(<Object?>[mockWater]),
        );
      });
    });

    group('LoadWater', () {
      test('supports value equality', () {
        expect(
          LoadWater(),
          equals(LoadWater()),
        );
      });

      test('props are correct', () {
        expect(
          LoadWater().props,
          equals(<Object?>[]),
        );
      });
    });
  });
}
