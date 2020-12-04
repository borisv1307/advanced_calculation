import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/next_operand_state.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_properties.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_tracking.dart';

class OperatorState extends State {

  @override
  ValidationProperties getNextState(String value, ValidationTracking tracking) {
    int counterValue = tracking.properties.counter;
    State state = ErrorState();
    if(Pattern.validOperand.hasMatch(value)){
      state = new NextOperandState();
    }
    else if(value == "("){
      counterValue = counterValue + 1;
      state = new OpenSubExpressionState();
    }

    return ValidationProperties(state, counterValue);
  }

}
