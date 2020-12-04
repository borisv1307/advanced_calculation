// This class is part of the state pattern and represents an abstract State class


abstract class State {
  int counter;
  bool multiParam;

  State(this.counter, this.multiParam);

  //abstract method
  State getNextState(String value);
}