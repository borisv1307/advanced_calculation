import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:flutter_test/flutter_test.dart';

ValidateFunction tester = new ValidateFunction();
void main(){
  group('input strings fail when not a valid math function:', () {

    group('invalid input', () {
      test('multiple decimals', () {
        var string = '3.45.6';
        expect(tester.findSyntaxError(string), 4);
      });

      test('undefined function', () {
        var string = 'abc(3+4)';
        expect(tester.findSyntaxError(string), 0);
      });

      test('unexpected negative sign', () {
        var string = '`345`45-2';
        expect(tester.findSyntaxError(string), 4);
      });

      test('lone decimal point', () {
        var string = '3+.';
        expect(tester.findSyntaxError(string), -1);
      });

      test('hanging decimal point', () {
        var string = '5-23.';
        expect(tester.findSyntaxError(string), -1);
      });

      test('junk input', () {
        var string = '23xA4G5';
        expect(tester.findSyntaxError(string), 2);
      });

      test('invalid comma position 1', () {
        var string = 'max(4,,2 )';
        expect(tester.findSyntaxError(string), 6);
      });

      test('invalid comma position 2', () {
        var string = 'max(4),';
        expect(tester.findSyntaxError(string), 6);
      });

      test('invalid comma position 3', () {
        var string = 'max(4,)';
        expect(tester.findSyntaxError(string), 6);
      });

      test('invalid comma position 4', () {
        var string = 'max(,4)';
        expect(tester.findSyntaxError(string), 4);
      });

      test('invalid comma function', () {
        var string = 'sin(4,2)';
        expect(tester.findSyntaxError(string), 5);
      });

      test('invalid complex comma function', () {
        var string = 'tan(2+sin(2),(3*4)*cos(2))';
        expect(tester.findSyntaxError(string), 12);
      });

      test('adding power', () {
        var string = '2+²';
        expect(tester.findSyntaxError(string), 2);
      });

      test('negative nothing', () {
        var string = '`';
        expect(tester.findSyntaxError(string), 1);
      });

      test('empty', () {
        var string = '';
        expect(tester.findSyntaxError(string), 0);
      });

      test('blank', () {
        var string = ' ';
        expect(tester.findSyntaxError(string), 0);
      });
    });
    
    group('no operands next to one another', () {
      test('no plus adjacent', () {
        var string = '2++2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no multiplication adjacent', () {
        var string = '2**2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no division adjacent', () {
        var string = '2//2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no subtraction adjacent', () {
        var string = '2--2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no double exponentiation', () {
        var string = '2^^2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no plus adj div', () {
        var string = '2+/2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no multiply adj plus', () {
        var string = '2*+2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no div adj multiply', () {
        var string = '2/*2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no div adj plus', () {
        var string = '2/+2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no sub adj plus', () {
        var string = '2-+2';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no exp adj div', () {
        var string = '2^/2';
        expect(tester.findSyntaxError(string), 2);
      });
    });

    group('invalid pairs of parentheses', () {
      test('no unmatched open', () {
        var string = '2*((2)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('no unmatched close', () {
        var string = '2/(2))';
        expect(tester.findSyntaxError(string), 5);
      });

      test('no empty parentheses', () {
        var string = '2*()';
        expect(tester.findSyntaxError(string), 3);
      });
      
      test('no unexpected close', () {
        var string = '2*)';
        expect(tester.findSyntaxError(string), 2);
      });

      test('no adjacent pairs', () {
        var string = '(2+2)(2+2)';
        expect(tester.findSyntaxError(string), 5);
      });

      test('invalid parenthesis', () {
        var string = 'max(4,2))';
        expect(tester.findSyntaxError(string), 8);
      });

      test('open without close no content', () {
        var string = '2(';
        expect(tester.findSyntaxError(string), 1);
      });
    });
  });

  group('input strings pass when a valid math function:', () {
    group('implied multiplication', () {
      test('before parenthesis', () {
        var string = '2(2)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('after parenthesis', () {
        var string = '(2)2';
        expect(tester.findSyntaxError(string), -1);
      });
    });

    group('symbols', () {
      test('e', () {
        var string = '2𝑒';
        expect(tester.findSyntaxError(string), -1);
      });

      test('pi', () {
        var string = '2𝜋';
        expect(tester.findSyntaxError(string), -1);
      });

      test('trailing symbol',(){
        var string = '𝜋2';
        expect(tester.findSyntaxError(string), -1);
      });
    });


      group('valid numbers', () {
      test('positive int', () {
        var string = '123';
        expect(tester.findSyntaxError(string), -1);
      });

      test('negative int', () {
        var string = '`30';
        expect(tester.findSyntaxError(string), -1);
      });

      test('double negative int', () {
        var string = '``30';
        expect(tester.findSyntaxError(string), -1);
      });

      test('positive decimal', () {
        var string = '45.31';
        expect(tester.findSyntaxError(string), -1);
      });

      test('negative decimal', () {
        var string = '`345.432';
        expect(tester.findSyntaxError(string), -1);
      });

      test('decimal operation', () {
        var string = '45.3*234.665';
        expect(tester.findSyntaxError(string), -1);
      });

      test('negative addition', () {
        var string = '45+`3';
        expect(tester.findSyntaxError(string), -1);
      });

      test('negative decimal division', () {
        var string = '`457.895/`34.5';
        expect(tester.findSyntaxError(string), -1);
      });
    });

    group('valid operators:', () {
      test('+', () {
        var string = '100+200';
        expect(tester.findSyntaxError(string), -1);
      });

      test('-', () {
        var string = '35-6523';
        expect(tester.findSyntaxError(string), -1);
      });

      test('/', () {
        var string = '`32/2';
        expect(tester.findSyntaxError(string), -1);
      });
      
      test('*', () {
        var string = '4555*`12';
        expect(tester.findSyntaxError(string), -1);
      });

      test('^', () {
        var string = '3^4';
        expect(tester.findSyntaxError(string), -1);
      });

      test('squared', () {
        var string = '2²';
        expect(tester.findSyntaxError(string), -1);
      });

      test('squared without number', () {
        var string = '²';
        expect(tester.findSyntaxError(string), 0);
      });

      test('squared trailing number', () {
        var string = '2²2';
        expect(tester.findSyntaxError(string), -1);
      });

      test('inverse', () {
        var string = '3⁻¹';
        expect(tester.findSyntaxError(string), -1);
      });
    });

    group('valid functions:', () {
      test('multiplied function', () {
        var string = '3ln(45)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('log', () {
        var string = 'log(111)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('ln', () {
        var string = 'ln(45)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('sin', () {
        var string = 'sin(33.3)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('cos', () {
        var string = 'cos(`87)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('tan', () {
        var string = 'tan(12)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('abs', () {
        var string = 'abs(`12345)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('csc', () {
        var string = 'csc(30)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('sec', () {
        var string = 'sec(5)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('cot', () {
        var string = 'cot(`3)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('sqrt', () {
        var string = 'sqrt(16)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('sinh', () {
        var string = 'sinh(`1)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('cosh', () {
        var string = 'cosh(12)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('tanh', () {
        var string = 'tanh(`2)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('asin', () {
        var string = 'asin(12)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('acos', () {
        var string = 'acos(5)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('atan', () {
        var string = 'atan(`30)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('acsc', () {
        var string = 'acsc(30)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('asec', () {
        var string = 'asec(3)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('acot', () {
        var string = 'acot(2)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('csch', () {
        var string = 'csch(20)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('sech', () {
        var string = 'sech(1)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('coth', () {
        var string = 'coth(`50)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('ceil', () {
        var string = 'ceil(7.004)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('asinh', () {
        var string = 'asinh(24)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('acosh', () {
        var string = 'acosh(3)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('atanh', () {
        var string = 'atanh(`10)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('acsch', () {
        var string = 'acsch(2)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('asech', () {
        var string = 'asech(4)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('acoth', () {
        var string = 'acoth(24)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('floor', () {
        var string = 'floor(`5.05)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('round', () {
        var string = 'round(24.56)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('trunc', () {
        var string = 'trunc(`32.9012)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('fract', () {
        var string = 'fract(0.5)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('square root', () {
        var expression = '√(4)';
        expect(tester.findSyntaxError(expression), -1);
      });
    });

    group('parentheses expressions:', () {
      test('single operand inside parentheses', () {
        var string = '(`30)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('single parentheses', () {
        var string = '3+(4*8)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('multi parentheses', () {
        var string = '5*(((`3)/4.5)+666)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('negative parentheses', () {
        var string = '4+`(30*2)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('basic negative parentheses', () {
        var string = '`(3)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('negative trig input', () {
        var string = '`sin(3)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('negative logarithmic input', () {
        var string = '`ln(300)';
        expect(tester.findSyntaxError(string), -1);
      });
    });

    group('complex expressions:', () {
      test('valid parentheses', () {
        var string = '(2+2)-2';
        expect(tester.findSyntaxError(string), -1);
      });

      test('sin and valid parentheses', () {
        var string = 'sin(2+(`4))-2';
        expect(tester.findSyntaxError(string), -1);
      });

      test('multi trig and  parentheses', () {
        var string = 'sin(2+cos(`4))-2';
        expect(tester.findSyntaxError(string), -1);
      });

      test('multi trig and  parentheses 2', () {
        var string = 'sin(2+cos(tan(2)-1))-2';
        expect(tester.findSyntaxError(string), -1);
      });

      test('multi trig and  parentheses 2', () {
        var string = 'sin(2+cos(tan(2)-1))-2';
        expect(tester.findSyntaxError(string), -1);
      });

      test('stacked functions', () {
        var string = '`log(floor(sinh(cos(atan(log(`round(sin(`10.3456)))))^sqrt(100.2))/cos(`5)))';
        expect(tester.findSyntaxError(string), -1);
      });

      test('simple max function with 1 parameter', () {
        var string = 'max(3)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('simple max function', () {
        var string = 'max(3,6)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('simple min function', () {
        var string = 'min(`3,6)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('simple gcd function', () {
        var string = 'gcd(2,10)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('simple lcm function', () {
        var string = 'lcm(3,4)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('multiple number of comma for max', () {
        var string = 'max(4,2,8)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('multiple number of comma for min', () {
        var string = 'min(4,2,8)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('multiple number of comma for gcd', () {
        var string = 'gcd(4,2,8)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('multiple number of comma for lcm', () {
        var string = 'lcm(4,2,8)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('complex max function', () {
        var string = 'max(2+sin(2),(3*4)*cos(2))';
        expect(tester.findSyntaxError(string), -1);
      });

      test('expression with mix parameters 1', () {
        var string = 'tan(2)+max(2+sin(2),(3*4)*cos(2))+cos(3)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('expressions with mix parameter 2', () {
        var string = 'max(2+sin(2),(3*4)*cos(2))+sin(2)+min(3,4)';
        expect(tester.findSyntaxError(string), -1);
      });

      test('expressions with multiple parameter', () {
        var string = 'max(2+sin(2),(3*4)*cos(2))+min(3,4)';
        expect(tester.findSyntaxError(string), -1);
      });
    });
  });
}
