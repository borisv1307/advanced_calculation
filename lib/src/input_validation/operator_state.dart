import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/next_operand_state.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';

class OperatorState extends State {

  OperatorState(int counter,bool multiParam) : super(counter, multiParam);

  @override
  State getNextState(String value) {
    State state = ErrorState(this.counter, this.multiParam);

    if(Pattern.validOperand.hasMatch(value)){
      state = new NextOperandState(this.counter, this.multiParam);
    }
    else if(value == "("){
      state = new OpenSubExpressionState(this.counter + 1, this.multiParam);
    }

    return state;
  }

}
