import 'start_state.dart';
import 'state.dart';

class ParseLocation{
  int counter = 0;
  State currentState;

  ParseLocation(this.currentState, this.counter);
}