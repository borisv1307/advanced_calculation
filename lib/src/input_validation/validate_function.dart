
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';

import 'open_subexpression_state.dart';

class ValidateFunction {
  State currentState;
  int counter = 0;
  List<String> lengthTwoFunc = ["ln"];
  List<String> lengthThreeFunc = ["log","sin","cos","tan", "abs", "csc","sec", "cot" ];
  List<String> lengthFourFunc = ["sqrt", "sinh", "cosh", "tanh", "asin", "acos", "atan", "acsc", "asec", "acot", "csch", "sech", "coth", "ceil"];
  List<String> lengthFiveFunc = ["asinh", "acosh", "atanh", "acsch", "asech", "acoth", "floor", "round", "trunc", "fract"];

  ValidateFunction(){
    currentState= new StartState(this);
  }

  void setCurrentState(State currentState) {
    this.currentState = currentState;
  }

  State getCurrentState() {
    return currentState;
  }

  bool testFunction(String input){
    this.counter = 0;
    input = input + " = ";
    List<String> inputString = input.split(" ");

    for(int i = 0; i < inputString.length; i++){
      if(inputString[i].isEmpty){
        inputString.removeAt(i);
      }
    }

    currentState= new StartState(this);

    for(int i = 0; i < inputString.length; i++){
      //handle special negatives for complex functions
      if(RegExp(r'^-[a-z]+$').hasMatch(inputString[i]) && inputString[i].length > 1) {
        inputString[i] = inputString[i].substring(1); // remove the negative
      }

      if(RegExp(r'^-?[0-9]+(.[0-9]+)?$').hasMatch(inputString[i]) || inputString[i].length == 1) {  // numbers or operands
        this.counter = currentState.getNextState(inputString[i], counter);

        if(currentState is ErrorState){
          return false;
        }
      }
      else if(inputString[i].length == 2){
        if(inputString[i] == "-("){
          // handle expression special case
          // Increment the counter and update state
          this.counter = this.counter + 1;
          currentState = new OpenSubExpressionState(this);
        }
        else if(lengthTwoFunc.contains(inputString[i]) == false){
          return false;
        }
      }
      else if(inputString[i].length == 3){
        if(lengthThreeFunc.contains(inputString[i]) == false){
          return false;
        }
      }
      else if(inputString[i].length == 4){
        if(lengthFourFunc.contains(inputString[i]) == false){
          return false;
        }
      }
      else if(inputString[i].length == 5){
        if(lengthFiveFunc.contains(inputString[i]) == false){
          return false;
        }
      }
      else {
        return false;
      }
    }

    return true;
  }

}
