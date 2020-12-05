import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/parse/expression_parser.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';
import 'start_state.dart';
import 'state.dart';

class ValidateFunction {
  ExpressionParser parser = ExpressionParser();

  static final List<String> validFunctions = ["ln","log","sin","cos","tan", "abs", "csc","sec", "cot", "sqrt", "sinh", "cosh", "tanh",
    "asin", "acos", "atan", "acsc", "asec", "acot", "csch", "sech", "coth", "ceil","asinh", "acosh", "atanh", "acsch", "asech",
    "acoth", "floor", "round", "trunc", "fract", "√", '-'];
  static final List<String> multiParamFunctions = ["max", "min", "gcd", "lcm"];
  static final List<String> operators = ['*','/','−','+','(',')','^',','];

  List<String> _sanitizeInput(String input){
    List<String> sanitizedInput = parser.padTokens(input).split(TranslatePattern.spacing).where((item) => item.isNotEmpty).toList();

    return sanitizedInput;
  }

  String _sanitizeToken(String token){
    String sanitizedToken = token;
    //handle special negatives for complex functions
    if(sanitizedToken.startsWith('-') && sanitizedToken.length > 1) {
      sanitizedToken = sanitizedToken.substring(1); // remove the negative
    }

    return sanitizedToken;
  }

  int findSyntaxError(String input) {
    int invalidTokenIndex = -1;
    List<String> inputString = _sanitizeInput(input);
    State currentState = StartState(0, false);

    for(int i=0;(i<inputString.length && invalidTokenIndex == -1);i++) {
      String token = _sanitizeToken(inputString[i]);

      if (operators.contains(token) ||
          Pattern.validOperand.hasMatch(token)) { // numbers or operands
        currentState = currentState.getNextState(token);
      } else if (multiParamFunctions.contains(token)) {
        currentState.multiParam = true;
      } else if(!validFunctions.contains(token)) {
        invalidTokenIndex =  i;
      }

      if(currentState is ErrorState) {
        invalidTokenIndex = i;
      }
    }

    int invalidIndex = _convertTokenIndex(invalidTokenIndex, inputString);

    return invalidIndex;
  }

  int _convertTokenIndex(int tokenIndex, List<String> tokens){
    int invalidIndex = tokenIndex;
    if(tokenIndex > 0){
      invalidIndex = List<int>.generate(tokenIndex, (i) => tokens[i].length).reduce((a, b) => a + b);
    }

    if(tokenIndex > -1){
      String token = tokens[tokenIndex];
      invalidIndex += _analyzeToken(token);
    }

    return invalidIndex;
  }

  int _analyzeToken(String token){
    int startIndex = token.startsWith('-') ? 1 : 0;
    bool match = false;
    int tokenMatch = token.length;
    for(;tokenMatch>=0 && !match;tokenMatch--){
      match = Pattern.validOperand.hasMatch(token.substring(startIndex,tokenMatch));
    }
    return tokenMatch + 1;
  }

  bool testMatrixFunction(String expression){
    bool valid = false;
    List<String> input = _sanitizeMatrixInput(expression);

    if(input.length > 1) {
      List<String> matrix1Values = input[0].replaceAll("&", "").split(RegExp(r'(!|,)'));
      String operator = input[1];
      List<String> matrix2Values = input[2].replaceAll("&", "").split(RegExp(r'(!|,)'));

      if (validateOperator(operator) && validateSize(input) && checkValues(matrix1Values, matrix2Values))
        valid = true;
    }

    return valid;
  }

  bool checkValues(List<String> matrix1Values, List<String> matrix2Values){
    for(int i = 0; i < matrix1Values.length; i++){
      String token = _sanitizeToken(matrix1Values[i]);
      if(!Pattern.validOperand.hasMatch(token))
        return false;
    }

    for(int i = 0; i < matrix2Values.length; i++) {
      String token = _sanitizeToken(matrix2Values[i]);
      if (!Pattern.validOperand.hasMatch(token))
        return false;
    }

    return true;
  }

  bool validateOperator(String value){
    if(Pattern.validOperator.hasMatch(value))
      return true;
    else
      return false;
  }

  bool validateSize(List<String> input){
    String matrix1 = input[0].replaceAll("&", "");
    String operator = input[1];
    String matrix2 = input[2].replaceAll("&", "");

    if(Pattern.addSubtractOperator.hasMatch(operator)){
      if(isRowSameSize(matrix1, matrix2) && isColumnSameSize(matrix1, matrix2))
        return true;
      else
        return false;
    }
    else if(Pattern.multiplyDivideOperator.hasMatch(operator)){
      if(isRowColSameSize(matrix1, matrix2))
        return true;
      else
        return false;
    }
    else
      return false;
  }

  bool isRowSameSize(String matrix1, String matrix2){
    List<String> rowsMatrix1 = matrix1.split("!");
    List<String> rowsMatrix2 = matrix2.split("!");

    if(rowsMatrix1.length == rowsMatrix2.length)
      return true;
    else
      return false;
  }

  bool isColumnSameSize(String matrix1, String matrix2){
    List<String> rowsMatrix1 = matrix1.split("!");
    List<String> rowsMatrix2 = matrix2.split("!");

    //need to check if correct number of columns exist in a row for matrix
    if(isValidColumns(rowsMatrix1) && isValidColumns(rowsMatrix2)) {
      List<String> colMatrix1 = rowsMatrix1[0].split(",");
      List<String> colMatrix2 = rowsMatrix2[0].split(",");

      if (colMatrix1.length == colMatrix2.length)
        return true;
      else
        return false;
    }
    else
      return false;
  }

  bool isRowColSameSize(String matrix1, String matrix2){
    List<String> rowsMatrix2 = matrix2.split("!");
    List<String> rowsMatrix1 = matrix1.split("!");

    //need to check if correct number of columns exist in a row for matrix
    if(isValidColumns(rowsMatrix1) && isValidColumns(rowsMatrix2)) {
      List<String> colMatrix1 = rowsMatrix1[0].split(",");

      if (rowsMatrix2.length == colMatrix1.length)
        return true;
      else
        return false;
    }
    else
      return false;
  }

  bool isValidColumns(List<String> rowsMatrix){
    int colSize = rowsMatrix[0].split(",").length;

    for (int i=0; i < rowsMatrix.length; i++) {
      List<String> colMatrix = rowsMatrix[i].split(",");
      if (colSize != colMatrix.length)
        return false;
    }

    return true;
  }

  List<String> _sanitizeMatrixInput(String input){
      input = input.replaceAll("+", " + ");
      input = input.replaceAll("−", " − ");
      input = input.replaceAll("*", " * ");
      input = input.replaceAll("/", " / ");

      List<String> sanitizedInput = input.split(TranslatePattern.spacing).where((item) => item.isNotEmpty).toList();

      return sanitizedInput;
  }

}
