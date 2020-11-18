import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

import 'first_operand_state.dart';

class StartState extends State {
  StartState(ValidateFunction context) : super(context);

  // The method is used to determine the next state for a given value
  // and used for transitioning from one state to another
  @override
  int getNextState(String value, int counter){
    if(RegExp(r'^-?[0-9]+(.[0-9]+)?$|^[𝜋𝑒]$', unicode: true).hasMatch(value)){
      //update state
      context.setCurrentState(new FirstOperandState(context));
    }
    else if(value == "("){
      counter = counter + 1;
      //update state
      context.setCurrentState(new OpenSubExpressionState(context));
    }
    else {
      //update state
      context.setCurrentState(new ErrorState(context));
    }

    return counter;
  }

}