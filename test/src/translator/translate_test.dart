import 'package:advanced_calculation/angular_unit.dart';
import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:flutter_test/flutter_test.dart';

Translator translator = new Translator();

void main() {

  group('correctly parses expression string', () {
    group('spacing:', () {
      test('add - no spacing', () {
        expect(translator.translate('2+2',CalculationOptions()), '2 + 2');
      });
      test('add - with spacing', () {
        expect(translator.translate('2 + 2',CalculationOptions()), '2 + 2');
      });
      test('minus - with spacing', () {
        expect(translator.translate('2 - 2',CalculationOptions()), '2 - 2');
      });
      test('multiply - no spacing', () {
        expect(translator.translate('2*2',CalculationOptions()), '2 * 2');
      });
      test('multiply - with spacing', () {
        expect(translator.translate('2*2',CalculationOptions()), '2 * 2');
      });
      test('divide - no spacing', () {
        expect(translator.translate('2/2',CalculationOptions()), '2 / 2');
      });
      test('divide - with spacing', () {
        expect(translator.translate('2/2',CalculationOptions()), '2 / 2');
      });
      test('exponent', () {
        expect(translator.translate('2^3',CalculationOptions()), '2 ^ 3');
      });
      test('parentheses', () {
        expect(translator.translate('(3)',CalculationOptions()), '( 3 )');
      });
      test('squared - no spacing', () {
        expect(translator.translate('3²',CalculationOptions()), '3 ^ 2');
      });
      test('squared - no spacing', () {
        expect(translator.translate('3 ²',CalculationOptions()), '3 ^ 2');
      });
      test('ln', () {
        expect(translator.translate('ln(3.1)',CalculationOptions()), 'ln ( 3.1 )');
      });
      test('commas', () {
        expect(translator.translate("max(3,5)",CalculationOptions()), 'max ( 3 , 5 )');
      });
      test('log', () {
        expect(translator.translate('log(11)',CalculationOptions()), 'log ( 11 )');
      });
      test('sin', () {
        expect(translator.translate('sin(40.1)',CalculationOptions()), 'sin ( 40.1 )');
      });
      test('cos', () {
        expect(translator.translate('cos(100)',CalculationOptions()), 'cos ( 100 )');
      });
      test('tan', () {
        expect(translator.translate('tan(3.0)',CalculationOptions()), 'tan ( 3.0 )');
      });
      test('length-4 functions', () {
        expect(translator.translate('asin(4.1)+cosh(2)',CalculationOptions()), 'asin ( 4.1 ) + cosh ( 2 )');
      });
      test('length-5 functions', () {
        expect(translator.translate('acosh(`9)+ atanh(3)',CalculationOptions()), 'acosh ( `1 * 9 ) + atanh ( 3 )');
      });
      test('x²', () {
        expect(translator.translate('4.0²',CalculationOptions()), '4.0 ^ 2');
      });
      test('sqrt', () {
        expect(translator.translate('√(4.0)',CalculationOptions()), 'sqrt ( 4.0 )');
      });
      test('x⁻¹', () {
        expect(translator.translate('3⁻¹',CalculationOptions()), '3 ^ `1');
      });
      test('preserve pi (𝜋)', () {
        expect(translator.translate('𝜋sin(4)+3𝜋 - 𝜋(4)',CalculationOptions()), '𝜋 * sin ( 4 ) + 3 * 𝜋 - 𝜋 * ( 4 )');
      });
      test('preserve e (𝑒)', () {
        expect(translator.translate('𝑒sin(4)+3𝑒 - 𝑒(4)',CalculationOptions()), '𝑒 * sin ( 4 ) + 3 * 𝑒 - 𝑒 * ( 4 )');
      });
      test('preserve negatives', () {
        expect(translator.translate('3 + `4*(`2 * `5)',CalculationOptions()), '3 + `1 * 4 * ( `1 * 2 * `1 * 5 )');
      });
    });
    group('correctly replaces symbols:', () {
      test('^2', () {
        expect(translator.translate('3²',CalculationOptions()), '3 ^ 2');
      });
      test('^-1', () {
        expect(translator.translate('2⁻¹',CalculationOptions()), '2 ^ `1');
      });
      test('x', () {
        expect(translator.translate('𝑥',CalculationOptions()), 'x');
      });
      test('sqrt', () {
        expect(translator.translate('√',CalculationOptions()), 'sqrt');
      });
      test('sqrt as function', () {
        expect(translator.translate('3√(4)',CalculationOptions()), '3 * sqrt ( 4 )');
      });
    });
    group('correctly parses simple matrix expression', () {
      test('1 matrix translation', () {
        List<String> testExpr = ["", "transpose", "&1;2;3@4;5;6@7;8;9@", "", "", "", "", "true"];
        List<String> results = translator.translateMatrixExpr(testExpr);
        expect(results[0], "null");
        expect(results[1], "transpose");
        expect(results[2], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[3], "null");
        expect(results[4], "&\$");
        expect(results[5], "1.0");
        expect(results[6], "1.0");
        expect(results[7], "true");
      });

      test('matrix operator matrix translation', () {
        List<String> testExpr = ["*", "", "&1;2;3@4;5;6@7;8;9@", "", "&1;2;3@4;5;6@7;8;9@", "", "", "false"];
        List<String> results = translator.translateMatrixExpr(testExpr);
        expect(results[0], "multiply");
        expect(results[1], "null");
        expect(results[2], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[3], "null");
        expect(results[4], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[5], "1.0");
        expect(results[6], "1.0");
        expect(results[7], "false");
      });

      test('Case1: matrix operator func matrix translation', () {
        List<String> testExpr = ["+", "", "&1;2;3@4;5;6@7;8;9@", "transpose", "&1;2;3@4;5;6@7;8;9@", "", "", "false"];
        List<String> results = translator.translateMatrixExpr(testExpr);
        expect(results[0], "add");
        expect(results[1], "null");
        expect(results[2], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[3], "transpose");
        expect(results[4], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[5], "1.0");
        expect(results[6], "1.0");
        expect(results[7], "false");
      });

      test('Case2: value operator func matrix translation', () {
        List<String> testExpr = ["/", "", "5", "permanent", "&1;2;3@4;5;6@7;8;9@", "", "", "false"];
        List<String> results = translator.translateMatrixExpr(testExpr);
        expect(results[0], "divide");
        expect(results[1], "determinant");
        expect(results[2], "&5\$");
        expect(results[3], "permanent");
        expect(results[4], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[5], "1.0");
        expect(results[6], "1.0");
        expect(results[7], "false");
      });

      test('Case1: func matrix operator matrix translation', () {
        List<String> testExpr = ["/", "transpose", "&1;2;3@4;5;6@7;8;9\$", "", "&1;2;3@4;5;6@7;8;9@", "", "", "false"];
        List<String> results = translator.translateMatrixExpr(testExpr);
        expect(results[0], "divide");
        expect(results[1], "transpose");
        expect(results[2], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[3], "null");
        expect(results[4], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[5], "1.0");
        expect(results[6], "1.0");
        expect(results[7], "false");
      });

      test('Case2: func matrix operator value translation', () {
        List<String> testExpr = ["*", "permanent", "&1;2;3@4;5;6@7;8;9\$", "", "𝜋", "", "", "false"];
        List<String> results = translator.translateMatrixExpr(testExpr);
        expect(results[0], "multiply");
        expect(results[1], "permanent");
        expect(results[2], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[3], "determinant");
        expect(results[4], "&𝜋\$");
        expect(results[5], "1.0");
        expect(results[6], "1.0");
        expect(results[7], "false");
      });

      test('Case1: func matrix operator func matrix translation', () {
        List<String> testExpr = ["+", "", "&1;2@3;4@", "", "&5;6@7;8@", "", "", "false"];
        List<String> results = translator.translateMatrixExpr(testExpr);
        expect(results[0], "add");
        expect(results[1], "null");
        expect(results[2], "&1;2@3;4\$");
        expect(results[3], "null");
        expect(results[4], "&5;6@7;8\$");
        expect(results[5], "1.0");
        expect(results[6], "1.0");
        expect(results[7], "false");
      });

      test('Case2: func matrix operator func matrix translation', () {
        List<String> testExpr = ["-", "", "&1;2;3@4;5;6@7;8;9@", "", "&1;2;3@4;5;6@7;8;9@", "", "2.5", "false"];
        List<String> results = translator.translateMatrixExpr(testExpr);
        expect(results[0], "subtract");
        expect(results[1], "null");
        expect(results[2], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[3], "null");
        expect(results[4], "&1;2;3@4;5;6@7;8;9\$");
        expect(results[5], "1.0");
        expect(results[6], "2.5");
        expect(results[7], "false");
      });
    });
    group('unclosed parentheses:', () {
      test('expression 1', () {
        expect(translator.translate('sin(sin(sin(sin(3',CalculationOptions()), 'sin ( sin ( sin ( sin ( 3 ) ) ) )');
      });
      test('expression 2', () {
        expect(translator.translate('(3 + sin(4 - 2 * (cos(50) / 2',CalculationOptions()), '( 3 + sin ( 4 - 2 * ( cos ( 50 ) / 2 ) ) )');
      });
    });
    group('add implied * sign:', () {
      test('number * constant', () {
        expect(translator.translate('3𝜋',CalculationOptions()), '3 * 𝜋');
      });
      test('x as constant', () {
        expect(translator.translate('3𝑥',CalculationOptions()), '3 * x');
      });
      test('number * function', () {
        expect(translator.translate('3log(10)',CalculationOptions()), '3 * log ( 10 )');
      });
      test('constant * number', () {
        expect(translator.translate('𝜋3',CalculationOptions()), '𝜋 * 3');
      });
      test('two constants', () {
        expect(translator.translate('𝜋𝑥',CalculationOptions()), '𝜋 * x');
      });
      test('constant * function', () {
        expect(translator.translate('𝑥sin(𝑥)',CalculationOptions()), 'x * sin ( x )');
      });
      test('number * parentheses', () {
        expect(translator.translate('4(3)',CalculationOptions()), '4 * ( 3 )');
      });
      test('constant * parentheses', () {
        expect(translator.translate('𝑒(5)',CalculationOptions()), '𝑒 * ( 5 )');
      });
      test('number * 2 constants', () {
        expect(translator.translate('4𝜋𝑒',CalculationOptions()), '4 * 𝜋 * 𝑒');
      });
      test('multiple constants', () {
        expect(translator.translate('3𝜋𝜋𝜋',CalculationOptions()), '3 * 𝜋 * 𝜋 * 𝜋');
      });
      test('preserve sign, decimal', () {
        expect(translator.translate('`3.41sin(10)',CalculationOptions()), '`1 * 3.41 * sin ( 10 )');
      });
      test('number after squared', () {
        expect(translator.translate('2²2',CalculationOptions()), '2 ^ 2 * 2');
      });
      test('number after -1', () {
        expect(translator.translate('2⁻¹2',CalculationOptions()), '2 ^ `1 * 2');
      });

      test('number after paren', () {
        expect(translator.translate('(2)2',CalculationOptions()), '( 2 ) * 2');
      });
    });

    group('Angular units',(){
      group('Degrees',(){
        CalculationOptions options;
        setUp((){
          options =  CalculationOptions();
          options.angularUnit = AngularUnit.DEGREE;
        });

        test('sin', () {
          expect(translator.translate('sin(2)',options), 'sin ( ( 𝜋 / 180 ) * 2 )');
        });

        test('cos', () {
          expect(translator.translate('cos(2)',options), 'cos ( ( 𝜋 / 180 ) * 2 )');
        });

        test('tan', () {
          expect(translator.translate('tan(2)',options), 'tan ( ( 𝜋 / 180 ) * 2 )');
        });

        test('sec', () {
          expect(translator.translate('sec(2)',options), 'sec ( ( 𝜋 / 180 ) * 2 )');
        });

        test('csc', () {
          expect(translator.translate('csc(2)',options), 'csc ( ( 𝜋 / 180 ) * 2 )');
        });

        test('cot', () {
          expect(translator.translate('cot(2)',options), 'cot ( ( 𝜋 / 180 ) * 2 )');
        });

        test('sinh', () {
          expect(translator.translate('sinh(2)',options), 'sinh ( ( 𝜋 / 180 ) * 2 )');
        });

        test('cosh', () {
          expect(translator.translate('cosh(2)',options), 'cosh ( ( 𝜋 / 180 ) * 2 )');
        });

        test('tanh', () {
          expect(translator.translate('tanh(2)',options), 'tanh ( ( 𝜋 / 180 ) * 2 )');
        });

        test('sech', () {
          expect(translator.translate('sech(2)',options), 'sech ( ( 𝜋 / 180 ) * 2 )');
        });

        test('csch', () {
          expect(translator.translate('csch(2)',options), 'csch ( ( 𝜋 / 180 ) * 2 )');
        });

        test('coth', () {
          expect(translator.translate('coth(2)',options), 'coth ( ( 𝜋 / 180 ) * 2 )');
        });

        test('asin', () {
          expect(translator.translate('asin(2)',options), 'asin ( ( 𝜋 / 180 ) * 2 )');
        });

        test('acos', () {
          expect(translator.translate('acos(2)',options), 'acos ( ( 𝜋 / 180 ) * 2 )');
        });

        test('atan', () {
          expect(translator.translate('atan(2)',options), 'atan ( ( 𝜋 / 180 ) * 2 )');
        });

        test('asec', () {
          expect(translator.translate('asec(2)',options), 'asec ( ( 𝜋 / 180 ) * 2 )');
        });

        test('acsc', () {
          expect(translator.translate('acsc(2)',options), 'acsc ( ( 𝜋 / 180 ) * 2 )');
        });

        test('acot', () {
          expect(translator.translate('acot(2)',options), 'acot ( ( 𝜋 / 180 ) * 2 )');
        });


        test('asinh', () {
          expect(translator.translate('asinh(2)',options), 'asinh ( ( 𝜋 / 180 ) * 2 )');
        });

        test('acosh', () {
          expect(translator.translate('acosh(2)',options), 'acosh ( ( 𝜋 / 180 ) * 2 )');
        });

        test('atanh', () {
          expect(translator.translate('atanh(2)',options), 'atanh ( ( 𝜋 / 180 ) * 2 )');
        });

        test('asech', () {
          expect(translator.translate('asech(2)',options), 'asech ( ( 𝜋 / 180 ) * 2 )');
        });

        test('acsch', () {
          expect(translator.translate('acsch(2)',options), 'acsch ( ( 𝜋 / 180 ) * 2 )');
        });

        test('acoth', () {
          expect(translator.translate('acoth(2)',options), 'acoth ( ( 𝜋 / 180 ) * 2 )');
        });


      });
    });
  });
}