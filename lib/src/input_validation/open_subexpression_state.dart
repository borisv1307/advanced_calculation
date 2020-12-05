import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'first_operand_state.dart';

class OpenSubExpressionState extends State {

  OpenSubExpressionState(int counter,bool multiParam) : super(counter, multiParam);

  @override
  State getNextState(String value){
    State state = ErrorState(this.counter, this.multiParam);

    if(value == "("){
      state = OpenSubExpressionState(this.counter + 1, this.multiParam);
    }
    else if(Pattern.validOperand.hasMatch(value)){
      state = new FirstOperandState(this.counter, this.multiParam);
    }

    return state;
  }

}