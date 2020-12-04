import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/parse_location.dart';
import 'open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';

class ValidateFunction {
  static final List<String> validFunctions = ["ln","log","sin","cos","tan", "abs", "csc","sec", "cot", "sqrt", "sinh", "cosh", "tanh",
    "asin", "acos", "atan", "acsc", "asec", "acot", "csch", "sech", "coth", "ceil","asinh", "acosh", "atanh", "acsch", "asech",
    "acoth", "floor", "round", "trunc", "fract"];
  static final List<String> multiParamFunctions = ["max", "min", "gcd", "lcm"];


  List<String> _sanitizeInput(String input){
    input = input + " = ";
    List<String> inputString = input.split(" ").where((item) => item.isNotEmpty).toList();

    return inputString;
  }

  bool testFunction(String input) {
    bool valid = true;

    bool isMultiParam = false;
    List<String> inputString = _sanitizeInput(input);
    ParseLocation location = ParseLocation();

    for(int i=0;(i<inputString.length && valid);i++) {
      String token = inputString[i];

      //handle special negatives for complex functions
      if(token.startsWith('-') && token.length > 1) {
        token = token.substring(1); // remove the negative
      }

      if(Pattern.validOperand.hasMatch(token) || token.length == 1) {  // numbers or operands
        location = location.currentState.getNextState(token, location.counter, isMultiParam);
        if(location.currentState is ErrorState)
          valid = false;
      } else if(multiParamFunctions.contains(token)){
        isMultiParam = true;
      } else if(!validFunctions.contains(token)) {
        valid =  false;
      }
    }

    return valid;
  }

}
