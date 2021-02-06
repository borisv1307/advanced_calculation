import 'dart:ffi';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// class TestableTranslator extends Translator{
//   LibraryLoader loader;
//   TestableTranslator(this.loader);
//
//   @override
//   LibraryLoader getLibraryLoader(){
//     return loader;
//   }
// }

class MockLibraryLoader extends Mock implements LibraryLoader{}

void main() {
  // group('Creates matrix translator',(){
  //   MockLibraryLoader loader;
  //   TestableTranslator calculator;
  //   setUpAll((){
  //     loader = MockLibraryLoader();
  //     calculator = TestableTranslator(loader);
  //   });
  //
  //   // test('is created',(){
  //   //   expect(calculator, isNotNull);
  //   // });
  //
  //   test('loads function upfront',(){
  //     verify(loader.loadCalculateFunction()).called(1);
  //   });
  // });

  group('Matrix calculated and reformatted',(){
    String actualOutput;
    List<int> matrixSize = [2,2];
    List<String> matrixValues = ["(1+2)","4","5", "6"];

    CalculateFunction calculateFunction = (Pointer<Utf8> input){
      return 3;
    };

    setUpAll((){
      MockLibraryLoader loader = MockLibraryLoader();
      when(loader.loadCalculateFunction()).thenReturn(calculateFunction);
      //TestableTranslator calculator = TestableTranslator(loader);//, translator);
      Translator calculator = new Translator();
      actualOutput = calculator.evaluateMatrix(matrixSize, matrixValues);
    });

    test('translated matrix output is received',(){
      expect(actualOutput, '&3;4@5;6\$');
    });
  });
}