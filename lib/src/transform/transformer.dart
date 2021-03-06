import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/transform/display_style_transformer.dart';
import 'package:advanced_calculation/src/transform/mantissa_transformer.dart';

class Transformer{
  final MantissaTransformer mantissaTransformer;
  final DisplayStyleTransformer displayStyleTransformer;

  Transformer({MantissaTransformer mantissaTransformer, DisplayStyleTransformer displayStyleTransformer}):
        mantissaTransformer = mantissaTransformer ?? MantissaTransformer(),
        displayStyleTransformer = displayStyleTransformer ?? DisplayStyleTransformer();

  String transform(double input, CalculationOptions options){
    String output = displayStyleTransformer.transform(input.toString(), options.displayStyle);
    output = mantissaTransformer.transform(output, options.decimalPlaces);
    return output;
  }
}