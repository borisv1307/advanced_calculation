import 'dart:ffi';
import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/coordinate_calculator.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class TestableCoordinateCalculator extends CoordinateCalculator{
  LibraryLoader loader;
  Translator translator;
  TestableCoordinateCalculator(this.loader, this.translator);

  @override
  LibraryLoader getLibraryLoader(){
    return loader;
  }
}

class MockLibraryLoader extends Mock implements LibraryLoader{}
class MockTranslator extends Mock implements Translator{}

void main() {
  group('Creates coordinate calculator',(){
    MockLibraryLoader loader;
    MockTranslator translator;
    TestableCoordinateCalculator calculator;
    setUpAll((){
      loader = MockLibraryLoader();
      translator = MockTranslator();
      calculator = TestableCoordinateCalculator(loader, translator);
    });

    test('is created',(){
      expect(calculator, isNotNull);
    });

    test('loads function upfront',(){
      verify(loader.loadGraphCalculateFunction()).called(1);
    });
  });

  group('Y value calculated',(){
    Pointer<Utf8> actualEquation;
    double actualX;
    double actualOutput;
    double calculate(Pointer<Utf8> equation, double x){
      actualEquation = equation;
      actualX = x;
      return 52;
    }

    setUpAll((){
      MockLibraryLoader loader = MockLibraryLoader();
      MockTranslator translator = MockTranslator();
      when(loader.loadGraphCalculateFunction()).thenReturn(calculate);
      when(translator.translate("2x",CalculationOptions())).thenReturn("2 * x");
      TestableCoordinateCalculator calculator = TestableCoordinateCalculator(loader, translator);
      actualOutput = calculator.calculate('2x',6);
    });

    test('equation is translated',(){
      expect(Utf8.fromUtf8(actualEquation),'2 * x');
    });

    test('x value is utilized',(){
      expect(actualX,6);
    });

    test('output is received',(){
      expect(actualOutput, 52);
    });
  });
}