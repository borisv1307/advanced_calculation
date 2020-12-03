
import 'package:advanced_calculation/advanced_calculator.dart';
import 'package:advanced_calculation/src/calculator.dart';
import 'package:advanced_calculation/src/coordinate_calculator.dart';
import 'package:advanced_calculation/src/matrix_calculator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCoordinateCalculator extends Mock implements CoordinateCalculator{}
class MockCalculator extends Mock implements Calculator{}
class MockMatrixCalculator extends Mock implements MatrixCalculator{}

class TestableAdvancedCalculator extends AdvancedCalculator{
  CoordinateCalculator coordinateCalculator;
  Calculator calculator;
  MatrixCalculator matrixCalculator;

  TestableAdvancedCalculator(this.calculator, this.coordinateCalculator, this.matrixCalculator);

  @override
  CoordinateCalculator getCoordinateCalculator(){
    return coordinateCalculator;
  }
  @override
  Calculator getCalculator(){
    return calculator;
  }
  @override
  MatrixCalculator getMatrixCalculator(){
    return matrixCalculator;
  }
}

void main() {
  MockCoordinateCalculator mockCoordinateCalculator;
  AdvancedCalculator advancedCalculator;
  Calculator mockCalculator;
  MatrixCalculator mockMatrixCalculator;

  setUp((){
    mockCoordinateCalculator = MockCoordinateCalculator();
    mockCalculator = MockCalculator();
    mockMatrixCalculator = MockMatrixCalculator();

    advancedCalculator = TestableAdvancedCalculator(mockCalculator,mockCoordinateCalculator,mockMatrixCalculator);
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

  test('Matrix calculator is utilized',(){
    when(mockMatrixCalculator.calculate('&1,2!3,4 + &2,-1!-1,2')).thenReturn('&3,1!2,6');

     String output = advancedCalculator.calculateMatrix('&1,2!3,4 + &2,-1!-1,2');
     expect(output, '&3,1!2,6');
     verify(mockMatrixCalculator.calculate('&1,2!3,4 + &2,-1!-1,2')).called(1);
  });

}
