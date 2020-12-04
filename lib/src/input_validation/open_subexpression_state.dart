import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_properties.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_tracking.dart';
import 'first_operand_state.dart';

class OpenSubExpressionState extends State {

  // The method is used to determine the next state for a given value
  // and used for transitioning from one state to another
  @override
  ValidationProperties getNextState(String value, ValidationTracking tracking){
    State state = ErrorState();
    int counterValue = tracking.properties.counter;
    if(value == "("){
      counterValue = counterValue + 1;
      state = OpenSubExpressionState();
    }
    else if(Pattern.validOperand.hasMatch(value)){
      state = new FirstOperandState();
    }
    else if(Pattern.validNoPlusMinusOperator.hasMatch(value)){
      state = new ErrorState();
    }
    else {
      state = new ErrorState();
    }

    return ValidationProperties(state, counterValue);
  }

}