import 'package:advanced_calculation/calculation_options.dart';
import 'package:test/test.dart';

void main(){
  group('Decimal places',(){
    test('Specified decimal places',(){
      expect(CalculationOptions(decimalPlaces: 2).decimalPlaces, 2);
    });
    test('Default decimal places',(){
      expect(CalculationOptions().decimalPlaces, -1);
    });
  });

}