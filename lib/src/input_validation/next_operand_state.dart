import 'package:advanced_calculation/src/input_validation/close_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

class NextOperandState extends State {
  NextOperandState(ValidateFunction context) : super(context);

  @override
  int getNextState(String value, int counterValue, bool isMultiParam) {
    if(Pattern.validCommaBasicOperator.hasMatch(value)){
      context.setCurrentState(new OperatorState(context));
    }
    else if(value == "="){
      // reaching here signifies a valid input expression
      if(counterValue > 0)
        context.setCurrentState(new ErrorState(context));
      else
        context.setCurrentState(new StartState(context));
    }

    else if(value.startsWith(")")){
      counterValue = counterValue - 1;
      context.setCurrentState(new CloseSubExpressionState(context));
    }
    else {
      context.setCurrentState(new ErrorState(context));
    }

    return counterValue;
  }
}
