import '../start_state.dart';
import '../state.dart';

class ValidationProperties{
  int counter;
  State currentState;

  ValidationProperties([State currentState, this.counter = 0]):
      this.currentState = currentState ?? StartState();

}