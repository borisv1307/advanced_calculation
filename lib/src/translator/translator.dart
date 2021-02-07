import 'package:advanced_calculation/angular_unit.dart';
import 'package:advanced_calculation/calculation_options.dart';
import 'package:advanced_calculation/src/input_validation/validate_matrix_function.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/parse/expression_parser.dart';
import 'package:advanced_calculation/src/transform/mantissa_transformer.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';
import 'package:ffi/ffi.dart';

class Translator {
  CalculateFunction calculateFunction;
  ValidateMatrixFunction validateMatrix = new ValidateMatrixFunction();
  CalculationOptions options = new CalculationOptions();
  MantissaTransformer transformer = new MantissaTransformer();
  ExpressionParser parser = ExpressionParser();
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

  String translateMatrixExpr(String input) {
    List<String> sanitizedInput = _sanitizeMatrixInput(input);

    // get the size of matrices
    List<int> matrix1Size =  _matrixSize(sanitizedInput[0]);
    List<int> matrix2Size =  _matrixSize(sanitizedInput[2]);

    // get the values of matrices and operator
    List<String> matrix1Values = sanitizedInput[0].replaceAll(RegExp(r'(&|\$)'), "").split(RegExp(r'(@|;)')).where((item) => item.isNotEmpty).toList();
    String operator = sanitizedInput[1];
    List<String> matrix2Values = sanitizedInput[2].replaceAll(RegExp(r'&|\$'), "").split(RegExp(r'(@|;)')).where((item) => item.isNotEmpty).toList();

    // simplify matrix values and recreate it
    String matrix1 = evaluateMatrix(matrix1Size, matrix1Values);
    String matrix2 = evaluateMatrix(matrix2Size, matrix2Values);

    String translated = matrix1 + " " + operator +  " " + matrix2;

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

  // translate matrix expression such as 'Matrix1+Matrix2'
  List<String> _sanitizeMatrixInput(String input){
    input = input.replaceAll("\$+&", "\$ + &");
    input = input.replaceAll("\$-&", "\$ - &");
    input = input.replaceAll("\$*&", "\$ * &");
    input = input.replaceAll("\$/&", "\$ / &");

    List<String> sanitizedInput = input.split(TranslatePattern.spacing).where((item) => item.isNotEmpty).toList();

    return sanitizedInput;
  }

  // returns the Matrix size as a list of [row, col]
  List<int> _matrixSize(String sanitizedInput){
    List<String> matrixRow = sanitizedInput.replaceAll(RegExp(r'(&|\$)'), "").split("@").where((item) => item.isNotEmpty).toList();
    int matrixRowSize = matrixRow.length;
    int matrixColSize = matrixRow[0].split(";").where((item) => item.isNotEmpty).toList().length;
    List<int> matrixSize = [matrixRowSize, matrixColSize];

    return matrixSize;
  }

  String evaluateMatrix(List<int> matrixSize, List<String> matrixValues){
    String matrix = "&";
    int count = 0;

    for(int r = 0; r < matrixSize[0]; r++){
      for(int c = 0; c < matrixSize[1]; c++) {
        String token = matrixValues[count];
        // check if math expression
        if (validateMatrix.isMathFunction(token)) {
          // evaluate the math expression
          String expression = translate(token, options);
          double results = calculateFunction(Utf8.toUtf8(expression));  // call to backend evaluator
          matrix += transformer.transform(results, options.decimalPlaces) + ";";
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
}