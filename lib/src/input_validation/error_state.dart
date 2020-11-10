// This class is part of the state pattern and inherits from abstract State class
// It represents the Error state for the calculator

import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';

class ErrorState extends State {
  ErrorState(ValidateFunction context) : super(context);

  //The method is used to determine the next state for a given value
  // and used for transitioning from one state to another
  @override
  int getNextState(String value, int counter) {
    return counter;
  }

}