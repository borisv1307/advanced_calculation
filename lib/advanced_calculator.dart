library advanced_calculation;

import 'package:advanced_calculation/src/calculator.dart';
import 'package:advanced_calculation/src/coordinate_calculator.dart';
import 'package:advanced_calculation/src/matrix_calculator.dart';

class AdvancedCalculator {
  CoordinateCalculator _coordinateCalculator;
  Calculator _calculator;
  MatrixCalculator _matrixCalculator;

  AdvancedCalculator(){
    _coordinateCalculator = getCoordinateCalculator();
    _calculator = getCalculator();
    _matrixCalculator = getMatrixCalculator();
  }


  double calculateEquation(String equation, double xValue){
    return _coordinateCalculator.calculate(equation, xValue);
  }

  String calculate(String input){
    return _calculator.calculate(input);
  }

  String calculateMatrix(String input) {
    return _matrixCalculator.calculate(input);
  }

  MatrixCalculator getMatrixCalculator(){
    return MatrixCalculator();
  }

  CoordinateCalculator getCoordinateCalculator(){
    return CoordinateCalculator();
  }

  Calculator getCalculator(){
    return Calculator();
  }



}
