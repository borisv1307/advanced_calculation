import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:advanced_calculation/syntax_exception.dart';
import 'package:ffi/ffi.dart';

import 'input_validation/validate_function.dart';
import 'library_loader.dart';
import 'translator/translator.dart';

class Calculator{
  final CalculateFunction calculateFunction;
  final ValidateFunction tester;
  final Translator translator;

  Calculator({LibraryLoader loader ,ValidateFunction validator, Translator translator}):
    calculateFunction = (loader ?? LibraryLoader()).loadCalculateFunction(),
    tester = validator ?? ValidateFunction(),
    translator = translator ?? Translator();

  String calculate(String input){
    String resultString;

    // convert display string to proper math format
    String expression = translator.translate(input);

    bool validInput = tester.testFunction(expression);
    if (validInput) {
      double results = calculateFunction(Utf8.toUtf8(expression));  // call to backend evaluator
      resultString = results.toString();
    } else {
      throw new SyntaxException(0);
    }
    return resultString;
  }
}