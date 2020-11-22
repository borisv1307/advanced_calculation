
import 'package:advanced_calculation/src/input_validation/close_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

import 'validate_function.dart';

class FirstOperandState extends State {
  FirstOperandState(ValidateFunction context) : super(context);

  @override
  int getNextState(String value, int counterValue, bool isMultiParam) {
    if(RegExp(r'^[+\-\/*^]$').hasMatch(value)){
      context.setCurrentState(new OperatorState(context));
    }
    else if(value == ","){
      if(isMultiParam)
        context.setCurrentState(new OperatorState(context));
      else
        context.setCurrentState(new ErrorState(context));
    }
    else if(value == "="){
      // reaching here signifies a valid input expression
      if(counterValue > 0)
        context.setCurrentState(new ErrorState(context));
      else
        context.setCurrentState(new StartState(context));
    }
    else if(value == "("){
      context.setCurrentState(new ErrorState(context)); 
    }
    else if(value == ")"){
      counterValue = counterValue - 1;
      context.setCurrentState(new CloseSubExpressionState(context));
    }
    else {
      context.setCurrentState(new ErrorState(context));
    }

    return counterValue;
  }
}
