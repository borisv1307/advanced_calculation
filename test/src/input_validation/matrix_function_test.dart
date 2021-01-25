import 'package:advanced_calculation/src/input_validation/validate_matrix_function.dart';
import 'package:flutter_test/flutter_test.dart';

ValidateMatrixFunction tester = new ValidateMatrixFunction();

void main() {
  group('test matrices validation', () {

    group('expression fail when not a valid matrices function:', () {
      test('invalid operator1', () {
        var string = '&1;2;3!^&4;5;6!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid operator2', () {
        var string = '&1;2;3sin!&4;5;6!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid comma separation', () {
        var string = '&1,2,3!+&4,5,6!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ with invalid matrices size', () {
        var string = '&1;2;3!+&`4;5;6!7;8;`9!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- with invalid matrices size', () {
        var string = '&1;2;3!-&`4;5;6!7;8;`9!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('* with invalid matrices size', () {
        var string = '&1;2;3!*&`4;5;6!7;8;`9!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('/ with invalid matrices size', () {
        var string = '&1;2;3!/&`4;5;6!7;8;`9!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ with invalid matrix 1', () {
        var string = '&1;2;abc!4;5;6!+&`4;5;6!7;8;`9!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- with invalid matrix 2', () {
        var string = '&1;2;3!0;1;2!-&`4;5;6!xyz;8;`9!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('* with invalid matrix 1', () {
        var string = '&1;2;3!4;5;6!`7;8;9!*&xyz;5;6!7;8;9!0;1;2!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('/ with invalid matrix 2', () {
        var string = '&1;2;3!0;0;1!/&4;5;6!1;2;abc!0;`2;5!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ with invalid number of rows in matrix 1', () {
        var string = '&1;2;3!4;5;6!+&`4;5;6!7;8;`9!0;1;2!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- with invalid number of columns in matrix 2', () {
        var string = '&1;2;3!0;1;2!-&`4;5;6!7;8!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('* with invalid number of rows in matrix 1', () {
        var string = '&1;2;3!`7;9!*&4;5;6!7;8;9!0;1;2!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('/ with invalid number of columns in matrix 2', () {
        var string = '&1;2;3!0;0;1!/&4;5;6!1;2!0,`2;5!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ for complex expression with size greater than 1x1 matrix', () {
        var string = '&1;𝑒abc;3^9!sin(6);`2;𝜋!+&`log(1000);5.6;6!√(16);7;`8⁻¹!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- for complex expression with size greater than 1x1 matrix', () {
        var string = '&`testing(3.5);2²;3!7;𝜋;`𝑒!−&`8⁻¹;5;6!0;0;0!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('2x3 * 3x2 with complex expression', () {
        var string = '&`cosx(5);2.5;`𝜋^3!4²;5;𝑒!*&√(4);fract(5.89)!`round(7.89);8⁻¹!ceil(0.1);1^4!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('1x1 / 1x2 with complex expression', () {
        var string = '&`abc𝜋!/&√(6.5);`acot(5.89)!';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid 1x1 / 1x2 with multi param expression', () {
        var string = '&`𝜋!/&√(6.5);`min(5.89,max(`6,9.2,))!';
        expect(tester.testMatrixFunction(string), equals(false));
      });
    });

    group('expression passes when a valid matrices function:', () {
      test('+ for 1x1 matrix', () {
        var string = '&1!+&4!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- for 1x1 matrix', () {
        var string = '&3!-&6!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* for 1x1 matrix', () {
        var string = '&3!*&5!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('/ for 1x1 matrix', () {
        var string = '&2!/&6!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ for size greater than 1x1 matrix', () {
        var string = '&1;2;3!6;`2;1!+&4;5;6!4;7;0!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- size greater than for 1x1 matrix', () {
        var string = '&1;2;3!7;8;`9!-&4;5;6!0;0;0!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* for size greater than 1x1 matrix', () {
        var string = '&1;2;3!4;5;6!`7;8;9!*&4;5;6!7;8;9!0;1;2!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('/ size greater than for 1x1 matrix', () {
        var string = '&111;2;3!0;0;1!/&4;5;6!1;2;3!0;`2;5!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('1x1 * 1x2', () {
        var string = '&1!*&4;5!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('2x3 / 3x2', () {
        var string = '&1;2;3!4;5;6!/&4;5!7;8!0;1!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ for complex expression with size greater than 1x1 matrix', () {
        var string = '&1;𝑒;3^9!sin(6);`2;𝜋!+&`log(1000);5.6;6!√(16);7;`8⁻¹!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- for complex expression with size greater than 1x1 matrix', () {
        var string = '&`tan(3.5);2²;3!7;𝜋;`𝑒!-&`8⁻¹;5;6!0;0;0!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('2x3 * 3x2 with complex expression', () {
        var string = '&`cos(5);2.5;`𝜋^3!4²;5;𝑒!*&√(4);fract(5.89)!`round(7.89);8⁻¹!ceil(0.1);1^4!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('1x1 / 1x2 with complex expression', () {
        var string = '&`𝜋!/&√(6.5);`acot(5.89)!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ for multi param expression with size greater than 1x1 matrix', () {
        var string = '&max(`1,4);𝑒;3^9!sin(6);`2;gcd(3,`12)!+&`log(1000);5.6;6!√(16);7;`8⁻¹!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- for multi param expression with size greater than 1x1 matrix', () {
        var string = '&`tan(3.5);2²;3!7;𝜋;`𝑒!-&`min(`3,`1);5;6!0;0;0!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('2x3 * 3x2 with multi param expression', () {
        var string = '&`cos(5);2.5;`max(1,2)^3!4²;5;𝑒!*&√(4);fract(min(`cos(9),gcd(3,6)))!`round(7.89);8!ceil(0.1);1^4!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('1x1 / 1x2 with multi param expression', () {
        var string = '&`𝜋!/&√(6.5);`min(5.89, max(`6,9.2))!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ with simple math expressions', () {
        var string = '&(1+2);(3-9)!(2*2);(0/9)!+&4;5!4;7!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- with simple math expressions', () {
        var string = '&(1+2);(3-9)!(2*2);(0/9)!-&4;5!4;7!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* with simple math expressions', () {
        var string = '&(1+2);(3-9)!(2*2);(0/9)!*&4;5!4;7!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* with simple math expressions', () {
        var string = '&(1+2);(3-9)!(2*2);(0/9)!/&4;5!4;7!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ with complicated math expressions', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))!(`𝑒*√(atan(2+6)));(0/9)!+&fract(min(`cos(9),gcd(3,6)));5!4;`7!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- with complicated math expressions', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))!(`𝑒*√(atan(2+6)));(0/9)!-&fract(min(`cos(9),gcd(3,6)));5!4;`7!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* with complicated math expressions', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))!(`𝑒*√(atan(2+6)));(0/9)!*&fract(min(`cos(9),gcd(3,6)));5!4;`7!';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('/ with complicated math expressions', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))!(`𝑒*√(atan(2+6)));(0/9)!/&fract(min(`cos(9),gcd(3,6)));5!4;`7!';
        expect(tester.testMatrixFunction(string), equals(true));
      });
    });

  });
}