import 'start_state.dart';
import 'start_state.dart';
import 'state.dart';

class ParseLocation{
  final int counter;
  final State currentState;

  ParseLocation([State currentState, this.counter = 0]):
      this.currentState = currentState ?? StartState();

}