import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/next_operand_state.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';

import 'validate_function.dart';

class OperatorState extends State {
  OperatorState(ValidateFunction context) : super(context);

  @override
  int getNextState(String value, int counterValue, bool isMultiParam) {
   if(Pattern.validOperand.hasMatch(value)){
      context.setCurrentState(new NextOperandState(context));
    }
    else if(Pattern.validAllOperator.hasMatch(value)){
      context.setCurrentState(new ErrorState(context));
    }
    else if(value == "("){
      counterValue = counterValue + 1;
      context.setCurrentState(new OpenSubExpressionState(context));
    }
    else {
      context.setCurrentState(new ErrorState(context));
    }    

    return counterValue;
  }

}
