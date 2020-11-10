import 'package:advanced_calculation/src/calculator.dart';

import 'src/coordinate_calculator.dart';

class AdvancedCalculation {
  CoordinateCalculator coordinateCalculator = CoordinateCalculator();
  Calculator calculator = Calculator();

  double calculateEquation(String equation, double xValue){
    return coordinateCalculator.calculate(equation, xValue);
  }

  String calculate(String input){
    return calculator.calculate(input);
  }

}
