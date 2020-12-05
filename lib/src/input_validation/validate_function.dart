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
    "acoth", "floor", "round", "trunc", "fract", "√", '-'];
  static final List<String> multiParamFunctions = ["max", "min", "gcd", "lcm"];
  static final List<String> operators = ['*','/','−','+','(',')','^',','];

  List<String> _sanitizeInput(String input){
    List<String> sanitizedInput = parser.padTokens(input).split(TranslatePattern.spacing).where((item) => item.isNotEmpty).toList();

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

  int checkSyntax(String input) {
    int invalidTokenIndex = -1;
    List<String> inputString = _sanitizeInput(input);
    State currentState = StartState(0, false);

    for(int i=0;(i<inputString.length && invalidTokenIndex == -1);i++) {
      String token = _sanitizeToken(inputString[i]);

      if(operators.contains(token) || Pattern.validOperand.hasMatch(token)) {  // numbers or operands
        currentState = currentState.getNextState(token);
      } else if(multiParamFunctions.contains(token)){
        currentState.multiParam = true;
      } else if(!validFunctions.contains(token)) {
        invalidTokenIndex =  i;
      }

      if(currentState is ErrorState) {
        invalidTokenIndex = i;
      }
    }

    int invalidIndex = _convertTokenIndex(invalidTokenIndex, inputString);

    return invalidIndex;
  }

  int _convertTokenIndex(int tokenIndex, List<String> tokens){
    int invalidIndex = tokenIndex;
    if(tokenIndex > 0){
      invalidIndex = List<int>.generate(tokenIndex, (i) => tokens[i].length).reduce((a, b) => a + b);
    }

    return invalidIndex;
  }

}
