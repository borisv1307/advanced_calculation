// This class is part of the state pattern and inherits from abstract State class
// It represents the Error state for the calculator

import 'package:advanced_calculation/src/input_validation/state.dart';

class ErrorState extends State {

  ErrorState(int counter,bool multiParam) : super(counter, multiParam);

  @override
  State getNextState(String value){
    return this;
  }

}