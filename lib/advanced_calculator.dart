library advanced_calculation;

import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/calculator.dart';
import 'package:advanced_calculation/src/conversions_calculator.dart';
import 'package:advanced_calculation/src/coordinate_calculator.dart';
import 'package:advanced_calculation/src/matrix_calculator.dart';

class AdvancedCalculator {
  CoordinateCalculator _coordinateCalculator;
  Calculator _calculator;
  MatrixCalculator _matrixCalculator;
  ConversionCalculator _conversionCalculator;

  AdvancedCalculator(){
    _coordinateCalculator = getCoordinateCalculator();
    _calculator = getCalculator();
    _matrixCalculator = getMatrixCalculator();
    _conversionCalculator = getConversionCalculator();
  }


  double calculateEquation(String equation, double xValue){
    return _coordinateCalculator.calculate(equation, xValue);
  }

  bool validateEquation(String equation){
    return _coordinateCalculator.verify(equation);
  }

  String calculate(String input, CalculationOptions options){
    return _calculator.calculate(input, options);
  }

  String calculateMatrix(String input) {
    return _matrixCalculator.calculate(input);
  }

  double calculateConversion(String input, double x){
    return _conversionCalculator.calculate(input, x);
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

  ConversionCalculator getConversionCalculator(){
    return ConversionCalculator();
  }

}
