import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';

class ValidateFunction {
  State currentState;
  bool isMultiParam = false;
  int multiParamCounter = 0; // Considers counting '(' for math functions with more than parameter
  int counter = 0; // Considers counting '(' for math functions with 1 parameter
  static final List<String> lengthTwoFunc = ["ln"];
  static final List<String> lengthThreeFunc = ["log","sin","cos","tan", "abs", "csc","sec", "cot" ];
  static final List<String> lengthFourFunc = ["sqrt", "sinh", "cosh", "tanh", "asin", "acos", "atan", "acsc", "asec", "acot", "csch", "sech", "coth", "ceil"];
  static final List<String> lengthFiveFunc = ["asinh", "acosh", "atanh", "acsch", "asech", "acoth", "floor", "round", "trunc", "fract"];
  static final List<String> lengthThreeMultiParamFunc = ["max", "min", "gcd", "lcm"];

  ValidateFunction(){
    currentState= new StartState(this);
  }

  void setCurrentState(State currentState) {
    this.currentState = currentState;
  }

  State getCurrentState() {
    return currentState;
  }

  List<String> initialize(String input){
    this.counter = 0;
    this.multiParamCounter = 0;
    isMultiParam = false;
    input = input + " = ";
    List<String> inputString = input.split(" ");

    for(int i = 0; i < inputString.length; i++){
      if(inputString[i].isEmpty){
        inputString.removeAt(i);
      }
    }

    return inputString;
  }

  void incrementCounter(){
    if(isMultiParam)
      this.multiParamCounter = this.multiParamCounter + 1;
    else
      this.counter = this.counter + 1;
  }

  bool testFunction(String input) {
    List<String> inputString = initialize(input);
    currentState= new StartState(this);

    for(int i = 0; i < inputString.length; i++) {
      //handle special negatives for complex functions
      if(RegExp(r'^-[a-z]+$').hasMatch(inputString[i]) && inputString[i].length > 1) {
        inputString[i] = inputString[i].substring(1); // remove the negative
      }

      if(Pattern.validOperand.hasMatch(inputString[i]) || inputString[i].length == 1) {  // numbers or operands
        if(this.isMultiParam)
          this.multiParamCounter = currentState.getNextState(inputString[i], multiParamCounter, isMultiParam);
        else
          this.counter = currentState.getNextState(inputString[i], counter, isMultiParam);

        if(currentState is ErrorState)
          return false;
      }
      else if(inputString[i].length == 2) {
        if(inputString[i] == "-(") {
          // handle expression special case and Increment the counter and update state
          incrementCounter();
          currentState = new OpenSubExpressionState(this);
        }
        else if(lengthTwoFunc.contains(inputString[i]) == false)
          return false;
      }
      else if(inputString[i].length == 3) {
        if(!lengthThreeFunc.contains(inputString[i]) && !lengthThreeMultiParamFunc.contains(inputString[i]) )
          return false;
        else if(lengthThreeMultiParamFunc.contains(inputString[i]))
          isMultiParam = true;
      }
      else if(inputString[i].length == 4) {
        if(lengthFourFunc.contains(inputString[i]) == false)
          return false;
      }
      else if(inputString[i].length == 5) {
        if(lengthFiveFunc.contains(inputString[i]) == false)
          return false;
      }
      else {
        return false;
      }
    }

    return true;
  }

}
