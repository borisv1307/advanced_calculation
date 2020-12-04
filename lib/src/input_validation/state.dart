// This class is part of the state pattern and represents an abstract State class

import 'package:advanced_calculation/src/input_validation/tracking/validation_properties.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_tracking.dart';

abstract class State {

  //abstract method
  ValidationProperties getNextState(String value, ValidationTracking tracking);
}