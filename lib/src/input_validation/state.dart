// This class is part of the state pattern and represents an abstract State class
import 'package:advanced_calculation/src/input_validation/parse_location.dart';

import 'validate_function.dart';

abstract class State {

  //abstract method
  ParseLocation getNextState(String value, int counterValue, bool isMultiParam);
}