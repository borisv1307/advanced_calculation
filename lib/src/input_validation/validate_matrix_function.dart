import 'package:advanced_calculation/src/input_validation/input_tokens.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';

class ValidateMatrixFunction {
  ValidateFunction validate = new ValidateFunction();

  bool testMatrixFunction(String expression){
    bool valid = false;
    List<String> input = _sanitizeMatrixInput(expression);

    if(input.length > 1) {
      List<String> matrix1Values = input[0].replaceAll("&", "").split(RegExp(r'(!|;)')).where((item) => item.isNotEmpty).toList();
      String operator = input[1];
      List<String> matrix2Values = input[2].replaceAll("&", "").split(RegExp(r'(!|;)')).where((item) => item.isNotEmpty).toList();

      if (validateOperator(operator) && validateSize(input) && checkValues(matrix1Values, matrix2Values))
        valid = true;
    }

    return valid;
  }

  bool checkValues(List<String> matrix1Values, List<String> matrix2Values){
    for(int i = 0; i < matrix1Values.length; i++){
      String token = validate.sanitizeToken(matrix1Values[i]);

      if(isMathFunction(token)){
        int syntaxErrorLocation = validate.findSyntaxError(token);
        if(syntaxErrorLocation != -1)
          return false;
      }
      else {
        if (!Pattern.validOperand.hasMatch(token))
          return false;
      }
    }

    for(int i = 0; i < matrix2Values.length; i++) {
      String token = validate.sanitizeToken(matrix2Values[i]);

      if(isMathFunction(token)){
        int syntaxErrorLocation = validate.findSyntaxError(token);
        if(syntaxErrorLocation != -1)
          return false;
      }
      else {
        if (!Pattern.validOperand.hasMatch(token))
          return false;
      }
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
    bool valid = false;

    if(Pattern.addSubtractOperator.hasMatch(operator) && isRowSameSize(matrix1, matrix2) && isColumnSameSize(matrix1, matrix2)){
      valid = true;
    }
    else if(Pattern.multiplyDivideOperator.hasMatch(operator) && isRowColSameSize(matrix1, matrix2)){
      valid = true;
    }

    return valid;
  }

  bool isRowSameSize(String matrix1, String matrix2){
    List<String> rowsMatrix1 = matrix1.split("!").where((item) => item.isNotEmpty).toList();
    List<String> rowsMatrix2 = matrix2.split("!").where((item) => item.isNotEmpty).toList();

    return rowsMatrix1.length == rowsMatrix2.length;
  }

  bool isColumnSameSize(String matrix1, String matrix2){
    List<String> rowsMatrix1 = matrix1.split("!").where((item) => item.isNotEmpty).toList();
    List<String> rowsMatrix2 = matrix2.split("!").where((item) => item.isNotEmpty).toList();
    bool valid = false;

    //need to check if correct number of columns exist in a row for matrix
    if(isValidColumns(rowsMatrix1) && isValidColumns(rowsMatrix2)) {
      List<String> colMatrix1 = rowsMatrix1[0].split(";");
      List<String> colMatrix2 = rowsMatrix2[0].split(";");

      if (colMatrix1.length == colMatrix2.length)
        valid = true;
    }

    return valid;
  }

  bool isRowColSameSize(String matrix1, String matrix2){
    List<String> rowsMatrix2 = matrix2.split("!").where((item) => item.isNotEmpty).toList();
    List<String> rowsMatrix1 = matrix1.split("!").where((item) => item.isNotEmpty).toList();
    bool valid = false;

    //need to check if correct number of columns exist in a row for matrix
    if(isValidColumns(rowsMatrix1) && isValidColumns(rowsMatrix2)) {
      List<String> colMatrix1 = rowsMatrix1[0].split(";");

      if (rowsMatrix2.length == colMatrix1.length)
        valid = true;
    }

    return valid;
  }

  bool isValidColumns(List<String> rowsMatrix){
    int colSize = rowsMatrix[0].split(";").length;

    for (int i=0; i < rowsMatrix.length; i++) {
      List<String> colMatrix = rowsMatrix[i].split(";");
      if (colSize != colMatrix.length)
        return false;
    }

    return true;
  }

  bool isMathFunction(String input){
    bool checker = false;

    if(InputTokens.specialOperators.any((element) => input.contains(element)) ||
        InputTokens.validFunctions.any((element) => input.contains(element)) ||
        InputTokens.multiParamFunctions.any((element) => input.contains(element)))
      checker = true;

    return checker;
  }

  List<String> _sanitizeMatrixInput(String input){
    input = input.replaceAll("!+&", "! + &");
    input = input.replaceAll("!-&", "! - &");
    input = input.replaceAll("!*&", "! * &");
    input = input.replaceAll("!/&", "! / &");

    List<String> sanitizedInput = input.split(TranslatePattern.spacing).where((item) => item.isNotEmpty).toList();

    return sanitizedInput;
  }
}