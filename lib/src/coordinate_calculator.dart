import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:ffi/ffi.dart';

class CoordinateCalculator {
  GraphCalculateFunction calculateFunction;
  Translator translator;
  ValidateFunction tester;

  CoordinateCalculator({LibraryLoader loader, Translator translator, ValidateFunction validator}) {
    this.calculateFunction = (loader ?? getLibraryLoader()).loadGraphCalculateFunction();
    this.translator = translator ?? Translator();
    this.tester = validator ?? ValidateFunction();
  }

  LibraryLoader getLibraryLoader(){
    return LibraryLoader();
  }

  bool verify(String equation) {
    int error = tester.findSyntaxError(equation);
    if (error == -1) 
      return true;
    else 
      return false;
  }
  
  double calculate(String equation, double xValue){
    String translated = translator.translate(equation,CalculationOptions());
    return calculateFunction(Utf8.toUtf8(translated), xValue);
  }
}