import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/next_operand_State.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

import 'validate_function.dart';

class OperatorState extends State {
  OperatorState(ValidateFunction context) : super(context);

  // The method is used to determine the next state for a given value
  // and used for transitioning from one state to another
  @override
  int getNextState(String value, int counterValue, bool isMultiParam) {
   if(RegExp(r'^-?[0-9]+(.[0-9]+)?$').hasMatch(value)){
      context.setCurrentState(new NextOperandState(context));
    }
    else if(RegExp(r'^[,+\-\/*^=)]$').hasMatch(value)){
      context.setCurrentState(new ErrorState(context));
    }
    else if(value == "("){
      counterValue = counterValue + 1;
      context.setCurrentState(new OpenSubExpressionState(context));
    }
    else {
      context.setCurrentState(new ErrorState(context));
    }    

    return counterValue;
  }

}
