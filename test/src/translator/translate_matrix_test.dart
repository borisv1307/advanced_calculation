import 'dart:ffi';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class TestableTranslator extends Translator{
  LibraryLoader loader;
  TestableTranslator(this.loader): super.withLibraryLoader(loader);
}

class MockLibraryLoader extends Mock implements LibraryLoader{}

void main() {
  group('Matrix calculated and reformatted correctly for complex math expressions',(){
    String actualOutput;
    List<int> matrixSize = [2,2]; //[row, column]
    List<String> matrixValues = ["(cos(0)+2)","4","5", "6"];

    CalculateFunction calculateFunction = (Pointer<Utf8> input){
      return 3;
    };

    setUpAll((){
      MockLibraryLoader loader = MockLibraryLoader();
      when(loader.loadCalculateFunction()).thenReturn(calculateFunction);
      TestableTranslator calculator = TestableTranslator(loader);
      actualOutput = calculator.evaluateMatrix(matrixSize, matrixValues);
    });

    test('translated matrix output is received',(){
      expect(actualOutput, '&3;4@5;6\$');
    });
  });
}