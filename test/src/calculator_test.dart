import 'dart:ffi';

import 'package:advanced_calculation/syntax_exception.dart';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:advanced_calculation/src/calculator.dart';

class MockLibraryLoader extends Mock implements LibraryLoader{}
class MockValidateFunction extends Mock implements ValidateFunction {}
class MockTranslator extends Mock implements Translator {}

void main(){
  test('Syntax error',(){
      MockLibraryLoader loader = MockLibraryLoader();
      MockValidateFunction validator = MockValidateFunction();
      MockTranslator translator = MockTranslator();
      CalculateFunction calculateFunction = (Pointer<Utf8> input){
        return 5;
      };

      when(loader.loadCalculateFunction()).thenReturn(calculateFunction);
      when(translator.translate('test input')).thenReturn('test expression');
      when(validator.checkSyntax('test input')).thenReturn(3);

      Calculator calculator = Calculator(loader: loader,validator: validator,translator: translator);
      bool thrown = false;
      try{
        calculator.calculate('test input');
      } on SyntaxException catch (e){
        thrown = true;
        expect(e.index,3);
      }
      expect(thrown,isTrue);
  });
}