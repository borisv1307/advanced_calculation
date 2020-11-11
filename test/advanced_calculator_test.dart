
import 'package:advanced_calculation/advanced_calculator.dart';
import 'package:advanced_calculation/src/calculator.dart';
import 'package:advanced_calculation/src/coordinate_calculator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCoordinateCalculator extends Mock implements CoordinateCalculator{}
class MockCalculator extends Mock implements Calculator{}

class TestableAdvancedCalculator extends AdvancedCalculator{
  CoordinateCalculator coordinateCalculator;
  Calculator calculator;

  TestableAdvancedCalculator(this.calculator, this.coordinateCalculator);

  @override
  CoordinateCalculator getCoordinateCalculator(){
    return coordinateCalculator;
  }
  @override
  Calculator getCalculator(){
    return calculator;
  }
}

void main() {
  MockCoordinateCalculator mockCoordinateCalculator;
  AdvancedCalculator advancedCalculator;
  Calculator mockCalculator;

  setUp((){
    mockCoordinateCalculator = MockCoordinateCalculator();
    mockCalculator = MockCalculator();

    advancedCalculator = TestableAdvancedCalculator(mockCalculator,mockCoordinateCalculator);
  });

  test('Coordinate calculator is utilized',(){
    when(mockCoordinateCalculator.calculate('x', 1)).thenReturn(2);

     double output = advancedCalculator.calculateEquation('x', 1);
     expect(output, 2);
     verify(mockCoordinateCalculator.calculate('x', 1)).called(1);
  });

  test('Calculator is utilized',(){
    when(mockCalculator.calculate('1+1')).thenReturn('2');

    String output = advancedCalculator.calculate('1+1');
    expect(output, '2');
    verify(mockCalculator.calculate('1+1')).called(1);
  });
}
