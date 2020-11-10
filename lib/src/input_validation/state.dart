// This class is part of the state pattern and represents an abstract State class
import 'validate_function.dart';

abstract class State {
  ValidateFunction context;

  State(ValidateFunction context) {
    this.context = context;
  }

  ValidateFunction getContext() {
    return this.context;
  }

  void setContext(ValidateFunction context) {
    this.context = context;
  }

  //abstract method
  int getNextState(String value, int counter);
}