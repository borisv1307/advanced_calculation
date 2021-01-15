import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:flutter_test/flutter_test.dart';

Translator translator = new Translator();

void main() {

  group('correctly parses expression string', () {
    group('spacing:', () {
      test('add - no spacing', () {
        expect(translator.translate('2+2'), '2 + 2');
      });
      test('add - with spacing', () {
        expect(translator.translate('2 + 2'), '2 + 2');
      });
      test('minus - with spacing', () {
        expect(translator.translate('2 − 2'), '2 - 2');
      });
      test('multiply - no spacing', () {
        expect(translator.translate('2*2'), '2 * 2');
      });
      test('multiply - with spacing', () {
        expect(translator.translate('2*2'), '2 * 2');
      });
      test('divide - no spacing', () {
        expect(translator.translate('2/2'), '2 / 2');
      });
      test('divide - with spacing', () {
        expect(translator.translate('2/2'), '2 / 2');
      });
      test('exponent', () {
        expect(translator.translate('2^3'), '2 ^ 3');
      });
      test('parentheses', () {
        expect(translator.translate('(3)'), '( 3 )');
      });
      test('squared - no spacing', () {
        expect(translator.translate('3²'), '3 ^ 2');
      });
      test('squared - no spacing', () {
        expect(translator.translate('3 ²'), '3 ^ 2');
      });
      test('ln', () {
        expect(translator.translate('ln(3.1)'), 'ln ( 3.1 )');
      });
      test('commas', () {
        expect(translator.translate("max(3,5)"), 'max ( 3 , 5 )');
      });
      test('log', () {
        expect(translator.translate('log(11)'), 'log ( 11 )');
      });
      test('sin', () {
        expect(translator.translate('sin(40.1)'), 'sin ( 40.1 )');
      });
      test('cos', () {
        expect(translator.translate('cos(100)'), 'cos ( 100 )');
      });
      test('tan', () {
        expect(translator.translate('tan(3.0)'), 'tan ( 3.0 )');
      });
      test('length-4 functions', () {
        expect(translator.translate('asin(4.1)+cosh(2)'), 'asin ( 4.1 ) + cosh ( 2 )');
      });
      test('length-5 functions', () {
        expect(translator.translate('acosh(-9)+ atanh(3)'), 'acosh ( -1 * 9 ) + atanh ( 3 )');
      });
      test('x²', () {
        expect(translator.translate('4.0²'), '4.0 ^ 2');
      });
      test('sqrt', () {
        expect(translator.translate('√(4.0)'), 'sqrt ( 4.0 )');
      });
      test('x⁻¹', () {
        expect(translator.translate('3⁻¹'), '3 ^ -1');
      });
      test('preserve pi (𝜋)', () {
        expect(translator.translate('𝜋sin(4)+3𝜋 − 𝜋(4)'), '𝜋 * sin ( 4 ) + 3 * 𝜋 - 𝜋 * ( 4 )');
      });
      test('preserve e (𝑒)', () {
        expect(translator.translate('𝑒sin(4)+3𝑒 − 𝑒(4)'), '𝑒 * sin ( 4 ) + 3 * 𝑒 - 𝑒 * ( 4 )');
      });
      test('preserve negatives', () {
        expect(translator.translate('3 + -4*(-2 * -5)'), '3 + -1 * 4 * ( -1 * 2 * -1 * 5 )');
      });
    });
    group('correctly replaces symbols:', () {
      test('^2', () {
        expect(translator.translate('3²'), '3 ^ 2');
      });
      test('^-1', () {
        expect(translator.translate('2⁻¹'), '2 ^ -1');
      });
      test('x', () {
        expect(translator.translate('𝑥'), 'x');
      });
      test('sqrt', () {
        expect(translator.translate('√'), 'sqrt');
      });
      test('sqrt as function', () {
        expect(translator.translate('3√(4)'), '3 * sqrt ( 4 )');
      });
    });
    group('correctly parses matrix expression', () {
      test('2x2', () {
        expect(translator.translateMatrixExpr('&1,2!3,4+&5,6!7,8'), '&1,2!3,4 + &5,6!7,8');
      });
      test('3x3', () {
        expect(translator.translateMatrixExpr('&1,2,3!4,5,6!7,8,9−&1,2,3!4,5,6!7,8,9'), '&1,2,3!4,5,6!7,8,9 − &1,2,3!4,5,6!7,8,9');
      });
    });
    group('unclosed parentheses:', () {
      test('expression 1', () {
        expect(translator.translate('sin(sin(sin(sin(3'), 'sin ( sin ( sin ( sin ( 3 ) ) ) )');
      });
      test('expression 2', () {
        expect(translator.translate('(3 + sin(4 − 2 * (cos(50) / 2'), '( 3 + sin ( 4 - 2 * ( cos ( 50 ) / 2 ) ) )');
      });
    });
    group('add implied * sign:', () {
      test('number * constant', () {
        expect(translator.translate('3𝜋'), '3 * 𝜋');
      });
      test('x as constant', () {
        expect(translator.translate('3𝑥'), '3 * x');
      });
      test('number * function', () {
        expect(translator.translate('3log(10)'), '3 * log ( 10 )');
      });
      test('constant * number', () {
        expect(translator.translate('𝜋3'), '𝜋 * 3');
      });
      test('two constants', () {
        expect(translator.translate('𝜋𝑥'), '𝜋 * x');
      });
      test('constant * function', () {
        expect(translator.translate('𝑥sin(𝑥)'), 'x * sin ( x )');
      });
      test('number * parentheses', () {
        expect(translator.translate('4(3)'), '4 * ( 3 )');
      });
      test('constant * parentheses', () {
        expect(translator.translate('𝑒(5)'), '𝑒 * ( 5 )');
      });
      test('number * 2 constants', () {
        expect(translator.translate('4𝜋𝑒'), '4 * 𝜋 * 𝑒');
      });
      test('multiple constants', () {
        expect(translator.translate('3𝜋𝜋𝜋'), '3 * 𝜋 * 𝜋 * 𝜋');
      });
      test('preserve sign, decimal', () {
        expect(translator.translate('-3.41sin(10)'), '-1 * 3.41 * sin ( 10 )');
      });
      test('number after squared', () {
        expect(translator.translate('2²2'), '2 ^ 2 * 2');
      });
      test('number after -1', () {
        expect(translator.translate('2⁻¹2'), '2 ^ -1 * 2');
      });

      test('number after paren', () {
        expect(translator.translate('(2)2'), '( 2 ) * 2');
      });
    });
  });
}