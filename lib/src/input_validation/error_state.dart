// This class is part of the state pattern and inherits from abstract State class
// It represents the Error state for the calculator

import 'package:advanced_calculation/src/input_validation/state.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_properties.dart';
import 'package:advanced_calculation/src/input_validation/tracking/validation_tracking.dart';

class ErrorState extends State {

  @override
  ValidationProperties getNextState(String value, ValidationTracking tracking){
    return ValidationProperties(ErrorState(), tracking.properties.counter);
  }

}