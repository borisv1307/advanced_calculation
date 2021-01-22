import 'dart:ffi';

import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/transform/mantissa_transformer.dart';
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
class MockMantissaTransformer extends Mock implements MantissaTransformer {}

void main(){
  test('Valid input',(){
    MockLibraryLoader loader = MockLibraryLoader();
    MockValidateFunction validator = MockValidateFunction();
    MockTranslator translator = MockTranslator();
    MockMantissaTransformer transformer = MockMantissaTransformer();
    CalculationOptions options = CalculationOptions();
    CalculateFunction calculateFunction = (Pointer<Utf8> input){
      return 5;
    };

    when(loader.loadCalculateFunction()).thenReturn(calculateFunction);
    when(translator.translate('test input')).thenReturn('test expression');
    when(validator.findSyntaxError('test input')).thenReturn(-1);
    when(transformer.transform(5, -1)).thenReturn('completed');

    Calculator calculator = Calculator(loader: loader,validator: validator,translator: translator,transformer: transformer);
    String result = calculator.calculate('test input',options);
    expect(result,'completed');
  });

  test('Syntax error',(){
      MockLibraryLoader loader = MockLibraryLoader();
      MockValidateFunction validator = MockValidateFunction();
      CalculateFunction calculateFunction = (Pointer<Utf8> input){
        return 5;
      };

      when(loader.loadCalculateFunction()).thenReturn(calculateFunction);
      when(validator.findSyntaxError('test input')).thenReturn(3);

      Calculator calculator = Calculator(loader: loader,validator: validator);
      bool thrown = false;
      try{
        calculator.calculate('test input',CalculationOptions());
      } on SyntaxException catch (e){
        thrown = true;
        expect(e.index,3);
      }
      expect(thrown,isTrue);
  });
}