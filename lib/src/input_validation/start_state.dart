import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'first_operand_state.dart';
import 'validate_function.dart';

class StartState extends State {
  StartState(ValidateFunction context) : super(context);

  @override
  int getNextState(String value, int counterValue, bool isMultiParam){
    if(RegExp(r'^-?[0-9]+(.[0-9]+)?$').hasMatch(value)){
      context.setCurrentState(new FirstOperandState(context));
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