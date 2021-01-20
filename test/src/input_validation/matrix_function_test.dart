import 'package:advanced_calculation/src/input_validation/validate_matrix_function.dart';
import 'package:flutter_test/flutter_test.dart';

ValidateMatrixFunction tester = new ValidateMatrixFunction();

void main() {
  group('test matrices validation', () {

    group('expression fail when not a valid matrices function:', () {
      test('invalid operator1', () {
        var string = '&1,2,3^&4,5,6';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid operator2', () {
        var string = '&1,2,3sin&4,5,6';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ with invalid matrices size', () {
        var string = '&1,2,3+&-4,5,6!7,8,-9';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- with invalid matrices size', () {
        var string = '&1,2,3-&-4,5,6!7,8,-9';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('* with invalid matrices size', () {
        var string = '&1,2,3*&-4,5,6!7,8,-9';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('/ with invalid matrices size', () {
        var string = '&1,2,3/&-4,5,6!7,8,-9';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ with invalid matrix 1', () {
        var string = '&1,2,abc!4,5,6+&-4,5,6!7,8,-9';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- with invalid matrix 2', () {
        var string = '&1,2,3!0,1,2-&-4,5,6!xyz,8,-9';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('* with invalid matrix 1', () {
        var string = '&1,2,3!4,5,6!-7,8,9*&xyz,5,6!7,8,9!0,1,2';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('/ with invalid matrix 2', () {
        var string = '&1,2,3!0,0,1/&4,5,6!1,2,abc!0,-2,5';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ with invalid number of rows in matrix 1', () {
        var string = '&1,2,3!4,5,6!+&-4,5,6!7,8,-9!0,1,2';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- with invalid number of columns in matrix 2', () {
        var string = '&1,2,3!0,1,2-&-4,5,6!7,8';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('* with invalid number of rows in matrix 1', () {
        var string = '&1,2,3!-7,9*&4,5,6!7,8,9!0,1,2';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('/ with invalid number of columns in matrix 2', () {
        var string = '&1,2,3!0,0,1/&4,5,6!1,2!0,-2,5';
        expect(tester.testMatrixFunction(string), equals(false));
      });
    });

    group('expression passes when a valid matrices function:', () {
      test('+ for 1x1 matrix', () {
        var string = '&1+&4';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- for 1x1 matrix', () {
        var string = '&3-&6';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* for 1x1 matrix', () {
        var string = '&3*&5';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('/ for 1x1 matrix', () {
        var string = '&2/&6';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ for size greater than 1x1 matrix', () {
        var string = '&1,2,3!6,`2,1+&4,5,6!4,7,0';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- size greater than for 1x1 matrix', () {
        var string = '&1,2,3!7,8,`9-&4,5,6!0,0,0';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* for size greater than 1x1 matrix', () {
        var string = '&1,2,3!4,5,6!`7,8,9*&4,5,6!7,8,9!0,1,2';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('/ size greater than for 1x1 matrix', () {
        var string = '&111,2,3!0,0,1/&4,5,6!1,2,3!0,`2,5';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('1x1 * 1x2', () {
        var string = '&1*&4,5';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('2x3 / 3x2', () {
        var string = '&1,2,3!4,5,6/&4,5!7,8!0,1';
        expect(tester.testMatrixFunction(string), equals(true));
      });
    });

  });
}