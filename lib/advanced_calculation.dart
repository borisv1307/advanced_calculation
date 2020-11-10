import 'src/graphing/coordinate_calculator.dart';

class AdvancedCalculation {
  CoordinateCalculator coordinateCalculator = CoordinateCalculator();

  double calculateEquation(String equation, double xValue){
    return coordinateCalculator.calculate(equation, xValue);
  }

}
