import 'file:///C:/Users/Greg/IdeaProjects/se-calc/advanced_calculation/lib/calculation_options.dart';
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