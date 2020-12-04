import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/parse_location.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'first_operand_state.dart';
import 'validate_function.dart';

class OpenSubExpressionState extends State {

  // The method is used to determine the next state for a given value
  // and used for transitioning from one state to another
  @override
  ParseLocation getNextState(String value, int counterValue, bool isMultiParam){
    State state = ErrorState();
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

    return ParseLocation(state, counterValue);
  }

}