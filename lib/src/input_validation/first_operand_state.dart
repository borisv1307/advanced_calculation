
import 'package:advanced_calculation/src/input_validation/close_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/parse_location.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

import 'validate_function.dart';

class FirstOperandState extends State {

  @override
  ParseLocation getNextState(String value, int counterValue, bool isMultiParam) {
    State state = ErrorState();
    if(Pattern.validBasicOperator.hasMatch(value)){
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
    else if(value == "("){
      state = new ErrorState();
    }
    else if(value == ")"){
      counterValue = counterValue - 1;
      state = new CloseSubExpressionState();
    }

    return ParseLocation(state,counterValue);
  }
}
