import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

import 'first_operand_state.dart';
import 'validate_function.dart';

class OpenSubExpressionState extends State {
  OpenSubExpressionState(ValidateFunction context) : super(context);

  // The method is used to determine the next state for a given value
  // and used for transitioning from one state to another
  @override
  int getNextState(String value, int counterValue, bool isMultiParam){
    if(value == "("){
      counterValue = counterValue + 1;
    }
    else if(RegExp(r'^-?[0-9]+(.[0-9]+)?$|^[𝜋𝑒]$', unicode: true).hasMatch(value)){
      context.setCurrentState(new FirstOperandState(context));
    }
    else if(RegExp(r'^[)^,*\/=]$').hasMatch(value)){
      context.setCurrentState(new ErrorState(context));
    }
    else {
      context.setCurrentState(new ErrorState(context));
    }

    return counterValue;
  }

}