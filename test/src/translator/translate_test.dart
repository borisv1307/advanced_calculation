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
        expect(translator.translate('3 ²'), '3  ^ 2');
      });
      test('ln', () {
        expect(translator.translate('ln(3.1)'), 'ln ( 3.1 )');
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
      test('preserve negatives', () {
        expect(translator.translate('3 + -4*(-2 * -5)'), '3 + -1 * 4 *  (  -1 * 2 * -1 * 5 )');
      });
    });
    group('unclosed parentheses:', () {
      test('expression 1', () {
        expect(translator.translate('sin(sin(sin(sin(3'), 'sin ( sin ( sin ( sin ( 3 ) ) ) )');
      });
      test('expression 2', () {
        expect(translator.translate('(3 + sin(4 − 2 * (cos(50) / 2'), '( 3 + sin ( 4 - 2 *  ( cos ( 50 )  / 2 ) ) )');
      });
    });
    group('add implied * sign:', () {
      test('expression 1', () {
        expect(translator.translate('2 + 3sin(4 + 4)'), '2 + 3 * sin ( 4 + 4 )');
      });
      test('expression 2', () {
        expect(translator.translate('4 + 3(9) − 2(4 + 3)'), '4 + 3 *  ( 9 )  - 2 *  ( 4 + 3 )');
      });
    });
  });
}