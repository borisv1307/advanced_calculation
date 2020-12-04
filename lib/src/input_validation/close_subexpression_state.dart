
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
    }
    else if(Pattern.validBasicOperator.hasMatch(value) || (value == "," && tracking.multiParam)){
        state = new OperatorState();
    }
    // reaching here signifies a valid input expression
    else if(value == "="  && counterValue <= 0){
        state = new StartState();
    }

    return ValidationProperties(state, counterValue);
  }

}