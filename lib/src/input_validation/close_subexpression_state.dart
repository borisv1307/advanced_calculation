
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

import 'validate_function.dart';

class CloseSubExpressionState extends State {
  CloseSubExpressionState(ValidateFunction context) : super(context);

  @override
  int getNextState(String value, int counterValue, bool isMultiParam){
    if(value == ")"){
      if(counterValue >= 1){
        counterValue = counterValue - 1;
        //remain in the same state
      }
      else {
        context.setCurrentState(new ErrorState(context));
      }
    }
    else if(Pattern.validBasicOperator.hasMatch(value)){
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
    else {
      context.setCurrentState(new ErrorState(context));
    }

    return counterValue;
  }

}