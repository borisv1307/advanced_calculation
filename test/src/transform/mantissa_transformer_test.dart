import 'package:advanced_calculation/src/transform/mantissa_transformer.dart';
import 'package:test/test.dart';

void main(){
  group('No specified precision',(){
    test('Decimal values',(){
      MantissaTransformer transformer = MantissaTransformer();
      String result = transformer.transform('5.25', -1);
      expect(result, '5.25');
    });

    test('No decimal values',(){
      MantissaTransformer transformer = MantissaTransformer();
      String result = transformer.transform('5', -1);
      expect(result, '5');
    });
  });

  test('Unneeded decimal places',(){
    MantissaTransformer transformer = MantissaTransformer();
    String result = transformer.transform('5', 2);
    expect(result, '5.00');
  });

  test('Specified decimal places of 0',(){
    MantissaTransformer transformer = MantissaTransformer();
    String result = transformer.transform('5.25', 0);
    expect(result, '5');
  });

  test('Specified decimal places round up',(){
    MantissaTransformer transformer = MantissaTransformer();
    String result = transformer.transform('5.25', 1);
    expect(result, '5.3');
  });

  test('Specified decimal places round down',(){
    MantissaTransformer transformer = MantissaTransformer();
    String result = transformer.transform('5.24', 1);
    expect(result, '5.2');
  });

  group('E',(){
    test('No decimal values',(){
      MantissaTransformer transformer = MantissaTransformer();
      String result = transformer.transform('5E0', -1);
      expect(result, '5E0');
    });

    test('Decimal values',(){
      MantissaTransformer transformer = MantissaTransformer();
      String result = transformer.transform('5.25E0', -1);
      expect(result, '5.25E0');
    });

    test('Specified decimal places of 0',(){
      MantissaTransformer transformer = MantissaTransformer();
      String result = transformer.transform('5.25E0', 0);
      expect(result, '5E0');
    });
  });
}