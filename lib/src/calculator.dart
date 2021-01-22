import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/transform/mantissa_transformer.dart';
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
  final MantissaTransformer transformer;

  Calculator({LibraryLoader loader ,ValidateFunction validator, Translator translator, MantissaTransformer transformer}):
    calculateFunction = (loader ?? LibraryLoader()).loadCalculateFunction(),
    tester = validator ?? ValidateFunction(),
    translator = translator ?? Translator(),
    transformer = transformer ?? MantissaTransformer();

  String calculate(String input, CalculationOptions options){
    String resultString;

    int syntaxErrorLocation = tester.findSyntaxError(input);
    // convert display string to proper math format
    if (syntaxErrorLocation == -1) {
      String expression = translator.translate(input);
      double results = calculateFunction(Utf8.toUtf8(expression));  // call to backend evaluator
      resultString = transformer.transform(results, options.decimalPlaces);
    } else {
      throw new SyntaxException(syntaxErrorLocation);
    }
    return resultString;
  }
}