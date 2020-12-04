import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/parse_location.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';

class ValidateFunction {
  State currentState;
  bool isMultiParam = false;
  int multiParamCounter = 0; // Considers counting '(' for math functions with more than parameter
  int counter = 0; // Considers counting '(' for math functions with 1 parameter
  static final List<String> validFunctions = ["ln","log","sin","cos","tan", "abs", "csc","sec", "cot", "sqrt", "sinh", "cosh", "tanh",
    "asin", "acos", "atan", "acsc", "asec", "acot", "csch", "sech", "coth", "ceil","asinh", "acosh", "atanh", "acsch", "asech",
    "acoth", "floor", "round", "trunc", "fract"];
  static final List<String> multiParamFunctions = ["max", "min", "gcd", "lcm"];

  ValidateFunction(){
    currentState= new StartState();
  }

  void setCurrentState(State currentState) {
    this.currentState = currentState;
  }

  State getCurrentState() {
    return currentState;
  }

  List<String> _initialize(String input){
    this.counter = 0;
    this.multiParamCounter = 0;
    isMultiParam = false;
    input = input + " = ";
    List<String> inputString = input.split(" ").where((item) => item.isNotEmpty).toList();

    return inputString;
  }

  void incrementCounter(){
    if(isMultiParam)
      this.multiParamCounter = this.multiParamCounter + 1;
    else
      this.counter = this.counter + 1;
  }

  bool testFunction(String input) {
    List<String> inputString = _initialize(input);
    currentState= new StartState();

    for(String token in inputString) {
      //handle special negatives for complex functions
      if(token.startsWith('-') && token.length > 1) {
        token = token.substring(1); // remove the negative
      }

      if(Pattern.validOperand.hasMatch(token) || token.length == 1) {  // numbers or operands
        ParseLocation location;
        if(this.isMultiParam) {
          location = currentState.getNextState(token, multiParamCounter, isMultiParam);
          this.multiParamCounter = location.counter;
        }else {
          location = currentState.getNextState(token, counter, isMultiParam);
          this.counter = location.counter;
        }
        currentState = location.currentState;

        if(currentState is ErrorState)
          return false;
      } else if(token == "-(") {
          // handle expression special case and Increment the counter and update state
          incrementCounter();
          currentState = new OpenSubExpressionState();
      } else if(multiParamFunctions.contains(token)){
        isMultiParam = true;
      } else if(!validFunctions.contains(token)) {
        return false;
      }
    }

    return true;
  }

}
