import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/parse/expression_parser.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';

import 'start_state.dart';
import 'state.dart';

class ValidateFunction {
  ExpressionParser parser = ExpressionParser();

  static final List<String> validFunctions = ["ln","log","sin","cos","tan", "abs", "csc","sec", "cot", "sqrt", "sinh", "cosh", "tanh",
    "asin", "acos", "atan", "acsc", "asec", "acot", "csch", "sech", "coth", "ceil","asinh", "acosh", "atanh", "acsch", "asech",
    "acoth", "floor", "round", "trunc", "fract", "√"];
  static final List<String> multiParamFunctions = ["max", "min", "gcd", "lcm"];
  static final List<String> operators = ['*','/','−','+','(',')','^',','];

  List<String> _sanitizeInput(String input){
    String trimmed = input;
    if(input.endsWith(',')){
      trimmed = input.substring(input.length - 1); // remove the negative
    }

    List<String> sanitizedInput = parser.padTokens(trimmed).split(TranslatePattern.spacing).where((item) => item.isNotEmpty).toList();

    return sanitizedInput;
  }

  String _sanitizeToken(String token){
    String sanitizedToken = token;
    //handle special negatives for complex functions
    if(sanitizedToken.startsWith('-') && sanitizedToken.length > 1) {
      sanitizedToken = sanitizedToken.substring(1); // remove the negative
    }

    return sanitizedToken;
  }

  bool testFunction(String input) {
    bool valid = true;
    List<String> inputString = _sanitizeInput(input);
    State currentState = StartState(0, false);

    for(int i=0;(i<inputString.length && valid);i++) {
      String token = _sanitizeToken(inputString[i]);

      if(operators.contains(token) || Pattern.validOperand.hasMatch(token)) {  // numbers or operands
        currentState = currentState.getNextState(token);
      } else if(multiParamFunctions.contains(token)){
        currentState.multiParam = true;
      } else if(!validFunctions.contains(token)) {
        valid =  false;
      }

      if(currentState is ErrorState) {
        valid = false;
      }
    }

    return valid;
  }

}
