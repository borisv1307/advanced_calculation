import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:ffi/ffi.dart';

class Calculator{
  CalculateFunction calculateFunction;
  ValidateFunction tester = new ValidateFunction();
  Translator translator = new Translator();

  Calculator() {
    calculateFunction = getLibraryLoader().loadCalculateFunction();
  }

  LibraryLoader getLibraryLoader(){
    return LibraryLoader();
  }

  String calculate(String input){
    String resultString;

    // convert display string to proper math format
    String expression = translator.translate(input);

    bool validInput = tester.testFunction(expression);
    if (validInput) {
      double results = calculateFunction(Utf8.toUtf8(expression));  // call to backend evaluator
      resultString = results.toString();
    } else {
      resultString = "Syntax Error";
    }
    return resultString;
  }
}