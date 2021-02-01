import 'package:advanced_calculation/angular_unit.dart';
import 'package:advanced_calculation/calculation_options.dart';
import 'package:test/test.dart';

void main(){
  group('Decimal places',(){
    test('Specified decimal places',(){
      CalculationOptions options = CalculationOptions();
      options.decimalPlaces = 2;
      expect(options.decimalPlaces, 2);
    });
    test('Default decimal places',(){
      expect(CalculationOptions().decimalPlaces, -1);
    });
  });

  group('Angular unit',(){
    test('Specified',(){
      CalculationOptions options = CalculationOptions();
      options.angularUnit = AngularUnit.DEGREE;
      expect(options.angularUnit, AngularUnit.DEGREE);
    });
    test('Default',(){
      expect(CalculationOptions().angularUnit, AngularUnit.RADIAN);
    });
  });

}