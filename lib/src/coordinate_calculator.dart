import 'package:advanced_calculation/src/library_loader.dart';
import 'package:ffi/ffi.dart';

class CoordinateCalculator {
  GraphCalculateFunction calculateFunction;

  CoordinateCalculator(){
    calculateFunction = getLibraryLoader().loadGraphCalculateFunction();
  }

  LibraryLoader getLibraryLoader(){
    return LibraryLoader();
  }

  double calculate(String equation, double xValue){
    double result = calculateFunction(Utf8.toUtf8(equation), xValue);
    return result;
  }
}