
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/parse_location.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

import 'error_state.dart';
import 'validate_function.dart';

class CloseSubExpressionState extends State {
  @override
  ParseLocation getNextState(String value, int counterValue, bool isMultiParam){
    State state = ErrorState();
    if(value == ")"){
      if(counterValue >= 1){
        counterValue = counterValue - 1;
        state= CloseSubExpressionState();
        //remain in the same state
      }
      else {
        state = new ErrorState();
      }
    }
    else if(Pattern.validBasicOperator.hasMatch(value)){
      state = new OperatorState();
    }
    else if(value == ","){
      if(isMultiParam)
        state = new OperatorState();
      else
        state = new ErrorState();
    }
    else if(value == "="){
      // reaching here signifies a valid input expression
      if(counterValue > 0)
        state = new ErrorState();
      else
        state = new StartState();
    }

    return ParseLocation(state, counterValue);
  }

}