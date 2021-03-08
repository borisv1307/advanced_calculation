import 'package:advanced_calculation/angular_unit.dart';
import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/parse/expression_parser.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';
import 'package:advanced_calculation/src/helper/matrix_helper.dart';
import 'package:ffi/ffi.dart';

class Translator {
  CalculateFunction calculateFunction;
  CalculationOptions options = new CalculationOptions();
  ExpressionParser parser = ExpressionParser();
  MatrixHelper helper = MatrixHelper();
  List<RegExp> impliedMultiplyPatterns = [TranslatePattern.numberX, TranslatePattern.xNumber,
    TranslatePattern.numberParen, TranslatePattern.xAdj, TranslatePattern.powerNumber, TranslatePattern.parenNumber];
  List<String> trigSuffixes = ['sin','cos','tan','sec','csc','cot','sinh','cosh','tanh','sech','csch','coth'];

  Translator();

  Translator.withLibraryLoader (LibraryLoader loader){
    calculateFunction = (loader ?? LibraryLoader()).loadCalculateFunction();
  }

// translates display values of a calculator expressions into proper format for processing
  String translate(String input, CalculationOptions options) {
    String translated = input;
    if (translated == null) return translated;
    translated = _angularUnits(translated,options);
    translated = _handleNegatives(translated);
    translated = _addImpliedMultiply(translated);
    translated = _convertSymbols(translated);
    translated = parser.padTokens(translated);
    translated = _handleX(translated);
    translated = _addClosingParentheses(translated);
    return translated.trim();
  }

  String _convertSymbols(String input){
    String result = input.replaceAll(" ²", " ^ 2 ");
    result = result.replaceAll("²", " ^ 2 ");
    result = result.replaceAll("⁻¹", " ^ `1 ");
    result = result.replaceAll("√", "sqrt");

    return result;
  }

  // must occur after adding implied multiply
  String _handleX(String input){ 
    return input.replaceAll("𝑥", "x");
  }

  // append missing closing parentheses
  String _addClosingParentheses(String input) {
    String result = input.trim() + " ";  // add ending space
    var openingMatches = TranslatePattern.openParen.allMatches(input);
    var closingMatches = TranslatePattern.closeParen.allMatches(input);
    for (var i = 0; i < openingMatches.length - closingMatches.length; i++) {
      result += ") ";
    }
    return result;
  }

  // change all tokens such as '3sin' into '3 * sin' and '3(' to '3 * ('
  String _addImpliedMultiply(String input) {
    String result = input;
    for (var i = 0; i < 2; i++) {  // runs twice for overlapping matches
      impliedMultiplyPatterns.forEach((pattern) {
        result = result.replaceAllMapped(pattern, (Match m) {
          return "${m.group(1)} * ${m.group(2)}";
        });
      });
    }
    return result;
  }

  String _handleNegatives(String input) {
    return input.replaceAll("`", " `1 * ");
  }

  List<String> translateMatrixExpr(List<String> validMatrixExpr) {
    String operator = _translateOperator(validMatrixExpr[0]);
    String matrixFunc1 = _translateMatrixFunc(validMatrixExpr[1]);
    String matrix1 = _translateMatrix(validMatrixExpr[2]);
    String matrixFunc2 = _translateMatrixFunc(validMatrixExpr[3]);
    String matrix2 = _translateMatrix(validMatrixExpr[4]);
    String scalar1 = _translateScalar(validMatrixExpr[5]);
    String scalar2 = _translateScalar(validMatrixExpr[6]);
    String isMatrix2Empty = validMatrixExpr[7];

    List<String> translated = [operator, matrixFunc1, matrix1, matrixFunc2, matrix2, scalar1, scalar2, isMatrix2Empty];

    return translated;
  }

  String _angularUnits(String input, CalculationOptions options) {
    String translated = input;
    if(options.angularUnit == AngularUnit.DEGREE){
      trigSuffixes.forEach((trigFunction) =>
        translated = translated.replaceAll(trigFunction + "(", trigFunction + "((𝜋/180)*"));
    }
    return translated;
  }

  String evaluateMatrix(List<int> matrixSize, List<String> matrixValues){
    String matrix = "&";
    int count = 0;

    for(int r = 0; r < matrixSize[0]; r++){
      for(int c = 0; c < matrixSize[1]; c++) {
        String token = matrixValues[count];
        // check if math expression
        if (helper.isMathFunction(token)) {
          // evaluate the math expression
          String expression = translate(token, options);
          double results = calculateFunction(Utf8.toUtf8(expression));  // call to backend evaluator
          matrix += results.toString() + ";";
        }
        else {
          matrix += token + ";";
        }
        count++;
      }
      matrix += "@";
    }
    matrix += "\$";

    // cleanup matrix string format
    matrix = matrix.replaceAll(";@", "@");
    matrix = matrix.replaceAll("@\$", "\$");

    return matrix;
  }

  String _translateOperator(String operator){
    String translatedOperator = "null";
    switch(operator){
      case "+":
        translatedOperator = "add";
        break;
      case "-":
        translatedOperator = "subtract";
        break;
      case "*":
        translatedOperator = "multiply";
        break;
      case "/":
        translatedOperator = "divide";
        break;
    }

    return translatedOperator;
  }

  String _translateMatrix(String matrix){
    if(helper.isMatrix(matrix)){
      List<int> matrixSize =  helper.matrixSize(matrix);
      List<String> matrixValues = helper.getMatrixValues(matrix);
      matrix = evaluateMatrix(matrixSize, matrixValues);
    }
    else if(matrix.isEmpty)
      matrix = "null";

    return matrix;
  }

  String _translateMatrixFunc(String matrixFunc){
    if(matrixFunc.isEmpty)
      matrixFunc = "null";

    return matrixFunc;
  }

  String _translateScalar(String scalar){
    if(scalar.isEmpty)
      scalar = "1.0";

    return scalar;
  }
}