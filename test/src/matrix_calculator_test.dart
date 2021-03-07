import 'dart:ffi';
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

  group('scalar Matrix operation calculated',(){
    Pointer<Utf8> actualMatrix1;
    Pointer<Utf8> actualOperand;
    Pointer<Utf8> actualMatrix2;
    double actualScalar1;
    double actualScalar2;
    String actualOutput;

    Pointer<Utf8> calculate(Pointer<Utf8> operator, Pointer<Utf8> matrixFunction1,
      Pointer<Utf8> matrix1, Pointer<Utf8> matrixFunction2, Pointer<Utf8> matrix2, double scalar1, double scalar2){
      actualMatrix1 = matrix1;
      actualOperand = operator;
      actualMatrix2 = matrix2;
      actualScalar1 = scalar1;
      actualScalar2 = scalar2;

      return Utf8.toUtf8('&6;8@10;12\$');
    }

    setUpAll((){
      List<String> expression = ["+", "", "&1;2@3;4@", "", "&1;1@1;1@", "2", "4"];
      List<String> translatedExpr = ["+", "null", "&1;2@3;4@", "null", "&1;1@1;1@", "2", "4"];
      MockLibraryLoader loader = MockLibraryLoader();
      MockTranslator translator = MockTranslator();
      when(translator.translateMatrixExpr(expression)).thenReturn(translatedExpr);
      when(loader.loadMatrixFunction()).thenReturn(calculate);
      TestableMatrixCalculator calculator = TestableMatrixCalculator(loader, translator);
      actualOutput = calculator.calculate('2(&1;2@3;4\$)+4(&1;1@1;1\$)');
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

    test('scalar1 is translated',(){
      expect(2.0, actualScalar1);
    });

    test('scalar2 is translated',(){
      expect(4.0, actualScalar2);
    });

    test('output is received',(){
      expect(actualOutput, '&6;8@10;12\$');
    });
  });
}