import 'package:advanced_calculation/src/input_validation/close_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/operator_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';

import 'error_state.dart';

class NextOperandState extends State {

  NextOperandState(int counter,bool multiParam) : super(counter, multiParam);

  @override
  State getNextState(String value){
    State state = ErrorState(this.counter,this.multiParam);
    if(Pattern.validCommaBasicOperator.hasMatch(value)){
      state = new OperatorState(this.counter,this.multiParam);
    }
    else if(value.startsWith(")")){
      state = new CloseSubExpressionState(this.counter - 1,this.multiParam);
    }

    return state;
  }
}
