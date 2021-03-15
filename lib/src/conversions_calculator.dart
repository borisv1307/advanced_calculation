import 'package:advanced_calculation/src/library_loader.dart';
import 'package:ffi/ffi.dart';

class ConversionCalculator{
  ConversionFunction conversionFunction;

  ConversionCalculator({LibraryLoader loader}) {
    conversionFunction = (loader ?? LibraryLoader()).loadConversionFunction();
  }

  double calculate(String input, double x){

      List<String> tokens = input.split(",");
      double resultPtr = conversionFunction(Utf8.toUtf8(tokens[0]),Utf8.toUtf8(tokens[1]),Utf8.toUtf8(tokens[2]),x);
      return resultPtr;
    }
  }
