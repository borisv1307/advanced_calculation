
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

class CloseSubExpressionState extends State {
  CloseSubExpressionState(ValidateFunction context) : super(context);

  // The method is used to determine the next state for a given value
  // and used for transitioning from one state to another
  @override
  int getNextState(String value, int counter){
    if(value == ")"){
      if(counter >= 1){
        counter = counter - 1;
        //remain in the same state
      }
      else {
        // update state
        context.setCurrentState(new ErrorState(context));
      }
    }
    else if(RegExp(r'^[+-/*^]$').hasMatch(value)){
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
    else {
      // update state
      context.setCurrentState(new ErrorState(context));
    }

    return counter;
  }

}