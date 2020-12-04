
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_properties.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_tracking.dart';

import 'error_state.dart';

class CloseSubExpressionState extends State {
  @override
  ValidationProperties getNextState(String value, ValidationTracking tracking){
    State state = ErrorState();
    int counterValue = tracking.properties.counter;
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
      if(tracking.multiParam)
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

    return ValidationProperties(state, counterValue);
  }

}