import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/parse_location.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'first_operand_state.dart';
import 'validate_function.dart';

class StartState extends State {

  @override
  ParseLocation getNextState(String value, int counterValue, bool isMultiParam){
    State state = ErrorState();
    if(Pattern.validOperand.hasMatch(value)){
      state = new FirstOperandState();
    }
    else if(value == "("){
      counterValue = counterValue + 1;
      state = new OpenSubExpressionState();
    }

    return ParseLocation(state, counterValue);
  }

}