import 'dart:ffi';
import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/matrix_calculator.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class TestableMatrixCalculator extends MatrixCalculator{
  LibraryLoader loader;
  Translator translator;
  TestableMatrixCalculator(this.loader, this.translator);

  @override
  LibraryLoader getLibraryLoader(){
    return loader;
  }
}

class MockLibraryLoader extends Mock implements LibraryLoader{}
class MockTranslator extends Mock implements Translator{}

void main() {
  group('Creates matrix calculator',(){
    MockLibraryLoader loader;
    MockTranslator translator;
    TestableMatrixCalculator calculator;
    setUpAll((){
      loader = MockLibraryLoader();
      translator = MockTranslator();
      calculator = TestableMatrixCalculator(loader, translator);
    });

    test('is created',(){
      expect(calculator, isNotNull);
    });

    test('loads function upfront',(){
      verify(loader.loadMatrixFunction()).called(1);
    });
  });

  group('Matrix calculated',(){
    Pointer<Utf8> actualMatrix1;
    Pointer<Utf8> actualOperand;
    Pointer<Utf8> actualMatrix2;
    String actualOutput;

    Pointer<Utf8> calculate(Pointer<Utf8> matrix1, Pointer<Utf8> matrix2, Pointer<Utf8> operand){
      actualMatrix1 = matrix1;
      actualOperand = operand;
      actualMatrix2 = matrix2;
      return Utf8.toUtf8('&2;3@4;5\$');
    }

    setUpAll((){
      MockLibraryLoader loader = MockLibraryLoader();
      MockTranslator translator = MockTranslator();
      when(translator.translate('&1;2@3;4\$+&1;1@1;1\$',CalculationOptions())).thenReturn('&1;2@3;4\$ + &1;1@1;1\$');
      when(loader.loadMatrixFunction()).thenReturn(calculate);
      TestableMatrixCalculator calculator = TestableMatrixCalculator(loader, translator);
      actualOutput = calculator.calculate('&1;2@3;4\$+&1;1@1;1\$');
    });

    test('matrix1 is translated',(){
      expect('&1;2@3;4\$',Utf8.fromUtf8(actualMatrix1));
    });

    test('matrix2 is translated',(){
      expect('&1;1@1;1\$',Utf8.fromUtf8(actualMatrix2));
    });

    test('operand is translated',(){
      expect('+',Utf8.fromUtf8(actualOperand));
    });

    test('output is received',(){
      expect(actualOutput, '&2;3@4;5\$');
    });
  });
}