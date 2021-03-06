import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/display_style.dart';
import 'package:advanced_calculation/src/transform/display_style_transformer.dart';
import 'package:advanced_calculation/src/transform/mantissa_transformer.dart';
import 'package:advanced_calculation/src/transform/transformer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockMantissaTransformer extends Mock implements MantissaTransformer{}
class MockDisplayStyleTransformer extends Mock implements DisplayStyleTransformer{}

void main(){
  MockMantissaTransformer mantissaTransformer;
  MockDisplayStyleTransformer displayStyleTransformer;
  String output;

  setUpAll((){
    mantissaTransformer = MockMantissaTransformer();
    when(mantissaTransformer.transform('1', -1)).thenReturn('2');

    displayStyleTransformer = MockDisplayStyleTransformer();
    when(displayStyleTransformer.transform('2', DisplayStyle.NORMAL)).thenReturn('3');

    Transformer transformer = Transformer(mantissaTransformer: mantissaTransformer,displayStyleTransformer: displayStyleTransformer);

    output = transformer.transform(1,CalculationOptions());
  });

  test('transforms mantissa',(){
    verify(mantissaTransformer.transform('1', -1)).called(1);
  });

  test('transforms style',(){
    verify(displayStyleTransformer.transform('2', DisplayStyle.NORMAL)).called(1);
  });

  test('transforms',(){
    expect(output,'3');
  });
}