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
    String trimmed = input;
    if(input.endsWith(',')){
      trimmed = input.substring(input.length - 1); // remove the negative
    }
    List<String> sanitizedInput = parser.padTokens(trimmed).split(TranslatePattern.spacing).where((item) => item.isNotEmpty).toList();

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

  bool testFunction(String input) {
    bool valid = true;
    List<String> inputString = _sanitizeInput(input);
    State currentState = StartState(0, false);

    for (int i = 0; (i < inputString.length && valid); i++) {
      String token = _sanitizeToken(inputString[i]);

      if (operators.contains(token) ||
          Pattern.validOperand.hasMatch(token)) { // numbers or operands
        currentState = currentState.getNextState(token);
      } else if (multiParamFunctions.contains(token)) {
        currentState.multiParam = true;
      } else if (!validFunctions.contains(token)) {
        valid = false;
      }
      if (currentState is ErrorState) {
        valid = false;
      }
    }

    return valid;
  }

  bool testMatrixFunction(String expression){
    List<String> input = expression.split(" ");
    List<String> matrix1Values = input[0].replaceAll("&", "").split(RegExp(r'(!|,)'));
    String operator = input[1];
    List<String> matrix2Values = input[2].replaceAll("&", "").split(RegExp(r'(!|,)'));

    if(validateOperator(operator) && validateSize(input) && checkValues(matrix1Values, matrix2Values))
      return true;
    else
      return false;
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


}
