
import 'package:advanced_calculation/src/input_validation/close_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

class FirstOperandState extends State {
  FirstOperandState(ValidateFunction context) : super(context);

  // The method is used to determine the next state for a given value
  // and used for transitioning from one state to another
  @override
  int getNextState(String value, int counter) {
    if(RegExp(r'^[+-/*^]$').hasMatch(value)){
      // update state
      context.setCurrentState(new OperatorState(context));
    }
    else if(value == "="){
      // reaching here signifies a valid input expression
      if(counter > 0){
        // update state
        context.setCurrentState(new ErrorState(context));
      }
      else {
        // update state
        context.setCurrentState(new StartState(context)); 
      }
    }
    else if(value == "("){
      // update state
      context.setCurrentState(new ErrorState(context)); 
    }
    else if(value == ")"){
      counter = counter - 1;
      // update state
      context.setCurrentState(new CloseSubExpressionState(context));
    }
    else {
      // update state
      context.setCurrentState(new ErrorState(context));
    }

    return counter;
  }
}
