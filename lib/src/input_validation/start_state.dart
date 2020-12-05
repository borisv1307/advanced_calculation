import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'first_operand_state.dart';

class StartState extends State {

  StartState(int counter,bool multiParam) : super(counter, multiParam);

  @override
  State getNextState(String value){
    State state = ErrorState(this.counter, this.multiParam);

    if(Pattern.validOperand.hasMatch(value)){
      state = new FirstOperandState(this.counter, this.multiParam);
    }
    else if(value == "("){
      state = new OpenSubExpressionState(this.counter + 1, this.multiParam);
    }

    return state;
  }
}