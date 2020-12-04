import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/next_operand_state.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/parse_location.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';

import 'validate_function.dart';

class OperatorState extends State {

  @override
  ParseLocation getNextState(String value, int counterValue, bool isMultiParam) {
     State state = ErrorState();
     if(Pattern.validOperand.hasMatch(value)){
       state = new NextOperandState();
      }
      else if(Pattern.validAllOperator.hasMatch(value)){
        state = new ErrorState();
      }
      else if(value == "("){
        counterValue = counterValue + 1;
        state = new OpenSubExpressionState();
      }
      else {
        state = new ErrorState();
      }

    return ParseLocation(state, counterValue);
  }

}
