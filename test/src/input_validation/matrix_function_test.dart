import 'package:advanced_calculation/src/input_validation/validate_matrix_function.dart';
import 'package:flutter_test/flutter_test.dart';

ValidateMatrixFunction tester = new ValidateMatrixFunction();

void main() {
  group('test matrices validation', () {

    group('expression fail when not a valid matrices function:', () {
      test('invalid operator1', () {
        var string = '&1;2;3\$^&4;5;6\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid operator2', () {
        var string = '&1;2;3sin\$/&4;5;6\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid comma separation', () {
        var string = '&1,2,3\$+&4,5,6\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ with invalid matrices size', () {
        var string = '&1;2;3\$+&`4;5;6@7;8;`9\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- with invalid matrices size', () {
        var string = '&1;2;3\$-&`4;5;6@7;8;`9\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('* with invalid matrices size', () {
        var string = '&1;2;3\$*&`4;5;6@7;8;`9\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('/ with invalid matrices size', () {
        var string = '&1;2;3\$/&`4;5;6@7;8;`9\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ with invalid matrix 1', () {
        var string = '&1;2;abc@4;5;6\$+&`4;5;6@7;8;`9\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- with invalid matrix 2', () {
        var string = '&1;2;3@0;1;2\$-&`4;5;6@xyz;8;`9\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('* with invalid matrix 1', () {
        var string = '&1;2;3@4;5;6@`7;8;9\$*&xyz;5;6@7;8;9@0;1;2\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('/ with invalid matrix 2', () {
        var string = '&1;2;3@0;0;1\$/&4;5;6@1;2;abc@0;`2;5\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ with invalid number of rows in matrix 1', () {
        var string = '&1;2;3@4;5;6\$+&`4;5;6@7;8;`9@0;1;2\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- with invalid number of columns in matrix 2', () {
        var string = '&1;2;3@0;1;2\$-&`4;5;6@7;8\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('* with invalid number of rows in matrix 1', () {
        var string = '&1;2;3@`7;9\$*&4;5;6@7;8;9@0;1;2\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('/ with invalid number of columns in matrix 2', () {
        var string = '&1;2;3@0;0;1\$/&4;5;6@1;2@0,`2;5\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('+ for complex expression with size greater than 1x1 matrix', () {
        var string = '&1;𝑒abc;3^9@sin(6);`2;𝜋\$+&`log(1000);5.6;6@√(16);7;`8⁻¹\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('- for complex expression with size greater than 1x1 matrix', () {
        var string = '&`testing(3.5);2²;3@7;𝜋;`𝑒\$−&`8⁻¹;5;6@0;0;0\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('2x3 * 3x2 with complex expression', () {
        var string = '&`cosx(5);2.5;`𝜋^3@4²;5;𝑒\$*&√(4);fract(5.89)@`round(7.89);8⁻¹@ceil(0.1);1^4\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('1x1 / 1x2 with complex expression', () {
        var string = '&`abc𝜋\$/&√(6.5);`acot(5.89)\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid 1x1 / 1x2 with multi param expression', () {
        var string = '&`𝜋\$/&√(6.5);`min(5.89,max(`6,9.2,))\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid matrix operations', () {
        var string = '&1;2;3@6;`2;1\$+&4;5;6@4;7;0\$+';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('not more than 2 matrix operations', () {
        var string = '&1;2;3@6;`2;1\$+&4;5;6@4;7;0\$+&4;5;6@4;7;0\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case for func matrix', () {
        var string = 'abc(&1;0@9;4\$)';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case: func matrix operator matrix 1', () {
        var string = 'abc(&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$)+&4;5@4;7\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case 1: matrix operator func matrix', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$-abc(&4;5@4;7\$)';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case 2: matrix operator func matrix', () {
        var string = '&-abc(&4;5@4;7\$)';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case: func matrix operator func matrix', () {
        var string = 'transpose(&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$)*something(&4;5@4;7\$)';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case: matrix + value', () {
        var string = '&1;2;3@7;8;`9\$+`𝜋';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid rref size', () {
        // that is, numCol != (numRows+1)
        var string = 'rref(&1;2;`3\$)';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid transpose size operation: transpose(2x3) + 2x2', () {
        var string = 'transpose(&1;2;3@7;8;`9\$)+&1;2@3;4\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case1: calculatedMatrix + value', () {
        var string = 'transpose(&1;2;3@7;8;`9\$)+`𝜋';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case2: calculatedMatrix + value', () {
        var string = '2.5(&1;2;3@7;8;`9\$)+`𝜋';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case1: value + calculatedMatrix', () {
        var string = '`𝜋+transpose(&1;2;3@7;8;`9\$)';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case2: value + calculatedMatrix', () {
        var string = '`𝜋*2.5(&1;2;3@7;8;`9\$)';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case: calculatedMatrixValue + matrix', () {
        var string = 'determinant(&1;2;3@7;8;`9\$)+&1;2;3@7;8;`9\$';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case: matrix + calculatedMatrixValue', () {
        var string = '&1;2;3@7;8;`9\$+determinant(&1;2;3@7;8;`9\$)';
        expect(tester.testMatrixFunction(string), equals(false));
      });

      test('invalid case: calculatedMatrix + calculatedMatrixValue', () {
        var string = 'transpose(&1;2;3@7;8;`9\$)+determinant(&1;2;3@7;8;`9\$)';
        expect(tester.testMatrixFunction(string), equals(false));
      });
    });

    group('expression passes when a valid matrices function:', () {
      test('+ for 1x1 matrix', () {
        var string = '&1\$+&4\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- for 1x1 matrix', () {
        var string = '&3\$-&4\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* for 1x1 matrix', () {
        var string = '&3\$*&5\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('/ for 1x1 matrix', () {
        var string = '&2\$/&6\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ for size greater than 1x1 matrix', () {
        var string = '&1;2;3@6;`2;1\$+&4;5;6@4;7;0\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- size greater than for 1x1 matrix', () {
        var string = '&1;2;3@7;8;`9\$-&4;5;6@0;0;0\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* for size greater than 1x1 matrix', () {
        var string = '&1;2;3@4;5;6@`7;8;9\$*&4;5;6@7;8;9@0;1;2\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('/ size greater than for 1x1 matrix', () {
        var string = '&111;2;3@0;0;1\$/&4;5;6@1;2;3@0;`2;5\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('1x1 * 1x2', () {
        var string = '&1\$*&4;5\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('2x3 / 3x2', () {
        var string = '&1;2;3@4;5;6\$/&4;5@7;8@0;1\$';
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "/");
        expect(tester.validMatrixExpression[1], "");
        expect(tester.validMatrixExpression[2], "&1;2;3@4;5;6@");
        expect(tester.validMatrixExpression[3], "");
        expect(tester.validMatrixExpression[4], "&4;5@7;8@0;1@");
        expect(tester.validMatrixExpression[5], "");
        expect(tester.validMatrixExpression[6], "");
      });

      test('+ for complex expression with size greater than 1x1 matrix', () {
        var string = '&1;𝑒;3^9@sin(6);`2;𝜋\$+&`log(1000);5.6;6@√(16);7;`8⁻¹\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- for complex expression with size greater than 1x1 matrix', () {
        var string = '&`tan(3.5);2²;3@7;𝜋;`𝑒\$-&`8⁻¹;5;6@0;0;0\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('2x3 * 3x2 with complex expression', () {
        var string = '&`cos(5);2.5;`𝜋^3@4²;5;𝑒\$*&√(4);fract(5.89)@`round(7.89);8⁻¹@ceil(0.1);1^4\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('1x1 / 1x2 with complex expression', () {
        var string = '&`𝜋\$/&√(6.5);`acot(5.89)\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ for multi param expression with size greater than 1x1 matrix', () {
        var string = '&max(`1,4);𝑒;3^9@sin(6);`2;gcd(3,`12)\$+&`log(1000);5.6;6@√(16);7;`8⁻¹\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- for multi param expression with size greater than 1x1 matrix', () {
        var string = '&`tan(3.5);2²;3@7;𝜋;`𝑒\$-&`min(`3,`1);5;6@0;0;0\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('2x3 * 3x2 with multi param expression', () {
        var string = '&`cos(5);2.5;`max(1,2)^3@4²;5;𝑒\$*&√(4);fract(min(`cos(9),gcd(3,6)))@`round(7.89);8@ceil(0.1);1^4\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('valid 1x1 / 1x2 with multi param', () {
        var string = '&`𝜋\$/&√(6.5);`min(5.89,9.2)\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ with simple math expressions', () {
        var string = '&(1+2);(3-9)@(2*2);(0/9)\$+&4;5@4;7\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- with simple math expressions', () {
        var string = '&(1+2);(3-9)@(2*2);(0/9)\$-&4;5@4;7\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* with simple math expressions', () {
        var string = '&(1+2);(3-9)@(2*2);(0/9)\$*&4;5@4;7\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('/ with simple math expressions', () {
        var string = '&(1+2);(3-9)@(2*2);(0/9)\$/&4;5@4;7\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('+ with complicated math expressions', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$+&fract(min(`cos(9),gcd(3,6)));5@4;`7\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('- with complicated math expressions', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$-&fract(min(`cos(9),gcd(3,6)));5@4;`7\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('* with complicated math expressions', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$*&fract(min(`cos(9),gcd(3,6)));5@4;`7\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('/ with complicated math expressions', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$/&fract(min(`cos(9),gcd(3,6)));5@4;`7\$';
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('case1: func matrix', () {
        var string = 'determinant(&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$)';
        List<String> result = tester.sanitizeMatrixInput(string);
        expect(result.length, 2);
        expect(result[0], 'determinant');
        expect(result[1], '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@');
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('case2: func matrix', () {
        // that is, numCols == (numRows+1)
        var string = 'rref(&1;2;`3@4;5;6\$)';
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "");
        expect(tester.validMatrixExpression[1], "rref");
        expect(tester.validMatrixExpression[2], "&1;2;`3@4;5;6@");
        expect(tester.validMatrixExpression[3], "");
        expect(tester.validMatrixExpression[4], "");
        expect(tester.validMatrixExpression[5], "");
        expect(tester.validMatrixExpression[6], "");
      });

      test('case: scalar matrix', () {
        var string = '2.5(&4;5@4;7\$)';
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "");
        expect(tester.validMatrixExpression[1], "");
        expect(tester.validMatrixExpression[2], "&4;5@4;7@");
        expect(tester.validMatrixExpression[3], "");
        expect(tester.validMatrixExpression[4], "");
        expect(tester.validMatrixExpression[5], "2.5");
        expect(tester.validMatrixExpression[6], "");
      });

      test('case: func matrix operator matrix', () {
        var string = 'transpose(&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$)+&4;5@4;7\$';
        List<String> result = tester.sanitizeMatrixInput(string);
        expect(result.length, 4);
        expect(result[0], 'transpose');
        expect(result[1], '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@');
        expect(result[2], '+');
        expect(result[3], '&4;5@4;7@');
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "+");
        expect(tester.validMatrixExpression[1], "transpose");
        expect(tester.validMatrixExpression[2], "&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@");
        expect(tester.validMatrixExpression[3], "");
        expect(tester.validMatrixExpression[4], "&4;5@4;7@");
        expect(tester.validMatrixExpression[5], "");
        expect(tester.validMatrixExpression[6], "");
      });

      test('case: func matrix operator value', () {
        var string = 'determinant(&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$)+4.3';
        List<String> result = tester.sanitizeMatrixInput(string);
        expect(result.length, 4);
        expect(result[0], 'determinant');
        expect(result[1], '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@');
        expect(result[2], '+');
        expect(result[3], '4.3');
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "+");
        expect(tester.validMatrixExpression[1], "determinant");
        expect(tester.validMatrixExpression[2], "&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@");
        expect(tester.validMatrixExpression[3], "");
        expect(tester.validMatrixExpression[4], "4.3");
        expect(tester.validMatrixExpression[5], "");
        expect(tester.validMatrixExpression[6], "");
      });

      test('case: scalar matrix operator matrix', () {
        var string = '2(&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$)+&4;5@4;7\$';
        List<String> result = tester.sanitizeMatrixInput(string);
        expect(result.length, 4);
        expect(result[0], '2');
        expect(result[1], '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@');
        expect(result[2], '+');
        expect(result[3], '&4;5@4;7@');
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "+");
        expect(tester.validMatrixExpression[1], "");
        expect(tester.validMatrixExpression[2], "&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@");
        expect(tester.validMatrixExpression[3], "");
        expect(tester.validMatrixExpression[4], "&4;5@4;7@");
        expect(tester.validMatrixExpression[5], "2");
        expect(tester.validMatrixExpression[6], "");
      });

      test('case: matrix operator func matrix', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$-transpose(&4;5@4;7\$)';
        List<String> result = tester.sanitizeMatrixInput(string);
        expect(result.length, 4);
        expect(result[0], '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@');
        expect(result[1], '-');
        expect(result[2], 'transpose');
        expect(result[3], '&4;5@4;7@');
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "-");
        expect(tester.validMatrixExpression[1], "");
        expect(tester.validMatrixExpression[2], "&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@");
        expect(tester.validMatrixExpression[3], "transpose");
        expect(tester.validMatrixExpression[4], "&4;5@4;7@");
        expect(tester.validMatrixExpression[5], "");
        expect(tester.validMatrixExpression[6], "");
      });

      test('case: matrix operator scalar matrix', () {
        var string = '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$-`𝜋(&4;5@4;7\$)';
        List<String> result = tester.sanitizeMatrixInput(string);
        expect(result.length, 4);
        expect(result[0], '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@');
        expect(result[1], '-');
        expect(result[2], '`𝜋');
        expect(result[3], '&4;5@4;7@');
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "-");
        expect(tester.validMatrixExpression[1], "");
        expect(tester.validMatrixExpression[2], "&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@");
        expect(tester.validMatrixExpression[3], "");
        expect(tester.validMatrixExpression[4], "&4;5@4;7@");
        expect(tester.validMatrixExpression[5], "");
        expect(tester.validMatrixExpression[6], "`𝜋");
      });

      test('case: value operator func matrix', () {
        var string = '2.5-permanent(&4;5@4;7\$)';
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "-");
        expect(tester.validMatrixExpression[1], "");
        expect(tester.validMatrixExpression[2], "2.5");
        expect(tester.validMatrixExpression[3], "permanent");
        expect(tester.validMatrixExpression[4], "&4;5@4;7@");
        expect(tester.validMatrixExpression[5], "");
        expect(tester.validMatrixExpression[6], "");
      });

      test('case1: func matrix operator func matrix', () {
        var string = 'transpose(&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$)*transpose(&4;5@4;7\$)';
        List<String> result = tester.sanitizeMatrixInput(string);
        expect(result.length, 5);
        expect(result[0], 'transpose');
        expect(result[1], '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@');
        expect(result[2], '*');
        expect(result[3], 'transpose');
        expect(result[4], '&4;5@4;7@');
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "*");
        expect(tester.validMatrixExpression[1], "transpose");
        expect(tester.validMatrixExpression[2], "&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@");
        expect(tester.validMatrixExpression[3], "transpose");
        expect(tester.validMatrixExpression[4], "&4;5@4;7@");
        expect(tester.validMatrixExpression[5], "");
        expect(tester.validMatrixExpression[6], "");
      });

      test('case2: func matrix operator func matrix', () {
        var string = 'determinant(&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$)*permanent(&4;5@4;7\$)';
        List<String> result = tester.sanitizeMatrixInput(string);
        expect(result.length, 5);
        expect(result[0], 'determinant');
        expect(result[1], '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@');
        expect(result[2], '*');
        expect(result[3], 'permanent');
        expect(result[4], '&4;5@4;7@');
        expect(tester.testMatrixFunction(string), equals(true));
      });

      test('case: scalar matrix operator scalar matrix', () {
        var string = '2.0(&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)\$)*`𝑒(&4;5@4;7\$)';
        List<String> result = tester.sanitizeMatrixInput(string);
        expect(result.length, 5);
        expect(result[0], '2.0');
        expect(result[1], '&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@');
        expect(result[2], '*');
        expect(result[3], '`𝑒');
        expect(result[4], '&4;5@4;7@');
        expect(tester.testMatrixFunction(string), equals(true));
        expect(tester.validMatrixExpression[0], "*");
        expect(tester.validMatrixExpression[1], "");
        expect(tester.validMatrixExpression[2], "&(1+sin(2*3));(3-(`𝜋*min(2,log(1000))))@(`𝑒*√(atan(2+6)));(0/9)@");
        expect(tester.validMatrixExpression[3], "");
        expect(tester.validMatrixExpression[4], "&4;5@4;7@");
        expect(tester.validMatrixExpression[5], "2.0");
        expect(tester.validMatrixExpression[6], "`𝑒");
      });
    });

  });
}