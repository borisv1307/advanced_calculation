import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:ffi/ffi.dart';

class CoordinateCalculator {
  final GraphCalculateFunction calculateFunction;
  final Translator translator;

  CoordinateCalculator({LibraryLoader loader, Translator translator}):
    calculateFunction = (loader ?? LibraryLoader()).loadGraphCalculateFunction(),
    translator = translator ?? Translator();


  double calculate(String equation, double xValue){
    String translated = translator.translate(equation);
    return calculateFunction(Utf8.toUtf8(translated), xValue);
  }
}