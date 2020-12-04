import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_tracking.dart';

import 'state.dart';

class ValidateFunction {
  static final List<String> validFunctions = ["ln","log","sin","cos","tan", "abs", "csc","sec", "cot", "sqrt", "sinh", "cosh", "tanh",
    "asin", "acos", "atan", "acsc", "asec", "acot", "csch", "sech", "coth", "ceil","asinh", "acosh", "atanh", "acsch", "asech",
    "acoth", "floor", "round", "trunc", "fract"];
  static final List<String> multiParamFunctions = ["max", "min", "gcd", "lcm"];


  List<String> _sanitizeInput(String input){
    List<String> sanitizedInput = input.split(" ").where((item) => item.isNotEmpty).toList();
    sanitizedInput.add('=');

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
    ValidationTracking tracking = ValidationTracking();

    for(int i=0;(i<inputString.length && valid);i++) {
      String token = _sanitizeToken(inputString[i]);

      if(Pattern.validOperand.hasMatch(token) || token.length == 1) {  // numbers or operands
        State currentState = tracking.properties.currentState;
        tracking.properties = currentState.getNextState(token, tracking);
      } else if(multiParamFunctions.contains(token)){
        tracking.multiParam = true;
      } else if(!validFunctions.contains(token)) {
        valid =  false;
      }

      if(tracking.properties.currentState is ErrorState) {
        valid = false;
      }
    }

    return valid;
  }

}
