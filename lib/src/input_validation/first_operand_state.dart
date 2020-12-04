
import 'package:advanced_calculation/src/input_validation/close_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';

class FirstOperandState extends State {

  FirstOperandState(int counter,bool multiParam) : super(counter, multiParam);

  @override
  State getNextState(String value){
    State state = ErrorState(this.counter, this.multiParam);

    if(Pattern.validBasicOperator.hasMatch(value)){
      state = new OperatorState(this.counter, this.multiParam);
    }
    else if(value == "," && this.multiParam){
      state = new OperatorState(this.counter, this.multiParam);
    }
    else if(value == ")"){
      state = new CloseSubExpressionState(this.counter - 1, this.multiParam);
    }
    else if(value == "("){
      state = new OpenSubExpressionState(this.counter + 1, this.multiParam);
    }

    return state;
  }
}
