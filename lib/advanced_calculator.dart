library advanced_calculation;

import 'package:advanced_calculation/src/calculator.dart';
import 'src/coordinate_calculator.dart';

class AdvancedCalculator {
  CoordinateCalculator _coordinateCalculator;
  Calculator _calculator;

  AdvancedCalculator(){
    _coordinateCalculator = getCoordinateCalculator();
    _calculator = getCalculator();
  }


  double calculateEquation(String equation, double xValue){
    return _coordinateCalculator.calculate(equation, xValue);
  }

  String calculate(String input){
    return _calculator.calculate(input);
  }

  CoordinateCalculator getCoordinateCalculator(){
    return CoordinateCalculator();
  }

  Calculator getCalculator(){
    return Calculator();
  }

}
