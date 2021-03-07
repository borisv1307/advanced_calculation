import 'package:advanced_calculation/src/input_validation/input_tokens.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';

class ValidateMatrixFunction {
  ValidateFunction validate = new ValidateFunction();
  String specialMatrixFunction = "";
  List<String> validMatrixExpression = new List<String>();

  // support different valid combinations for 2 matrix operations only
  bool testMatrixFunction(String expression){
    bool valid = false;
    List<String> input = sanitizeMatrixInput(expression);
    int inputSize = input.length;

    // Case: matrixFunction matrix
    // eg: transpose (matrix)
    if(inputSize == 2){
      String matrixFunction = input[0];
      List<String> matrix1Values = _getMatrixValues(input[1]);

      if(_sanitizeMatrixFunction(matrixFunction, input[1]) &&
          _isValidMatrixFunction(specialMatrixFunction, input[1].replaceAll("&", "")) &&
          _checkValues(matrix1Values))
        valid = true;
    }
    // Case: matrix operation matrix
    // eg: matrix1 + matrix2
    else if(inputSize == 3){
      List<String> matrix1Values = _getMatrixValues(input[0]);
      String operator = input[1];
      List<String> matrix2Values = _getMatrixValues(input[2]);

      if (_validateOperator(operator) &&
          _validateSize(input[0].replaceAll("&", ""), input[2].replaceAll("&", ""), operator) &&
          _checkValues(matrix1Values) && _checkValues(matrix2Values)) {
        valid = true;
        _createValidMatrixExp(operator, "", input[0], "", input[2]);
      }
    }
    else if(inputSize == 4){
      // Cases: matrixFunction matrix operation matrix/Value
      // eg: transpose (matrix1) + matrix2
      // eg. determinant (matrix1) + 2
      if(_isValidMatrixFunction(input[0], input[1].replaceAll("&", ""))){
        String matrixFunction = input[0];
        List<String> matrix1Values = _getMatrixValues(input[1]);
        String operator = input[2];
        List<String> matrix2Values = _getMatrixValues(input[3]);

          if (_validateOperator(operator) &&
              _validateMatrixFuncSize(matrixFunction, "", input[1], input[3], operator) &&
              _checkValues(matrix1Values) && _checkValues(matrix2Values)) {
            valid = true;
            _createValidMatrixExp(operator, matrixFunction, input[1], "", input[3]);
          }
      }
      // Cases: matrix/Value operation matrixFunction matrix
      // eg: matrix1 + transpose (matrix2)
      // eg. 2 + transpose (matrix2)
      else if(input[0].contains("&")){
        List<String> matrix1Values = _getMatrixValues(input[0]);
        String operator = input[1];
        String matrixFunction = input[2];
        List<String> matrix2Values = _getMatrixValues(input[3]);

        if (_validateOperator(operator) && _isValidMatrixFunction(matrixFunction, input[3].replaceAll("&", "")) &&
            _validateMatrixFuncSize(matrixFunction, "", input[3], input[0], operator) &&
            _checkValues(matrix1Values) && _checkValues(matrix2Values)) {
          valid = true;
          _createValidMatrixExp(operator, "", input[0], matrixFunction, input[3]);
        }
      }
    }
    // Cases: matrixFunction matrix/Value operation matrixFunction matrix/Value
    // eg: transpose (matrix1) + transpose (matrix2)
    // eg. determinant (matrix1) + permanent (matrix2)
    else if(inputSize == 5){
      String matrixFunction1 = input[0];
      List<String> matrix1Values = _getMatrixValues(input[1]);
      String operator = input[2];
      String matrixFunction2 = input[3];
      List<String> matrix2Values = _getMatrixValues(input[4]);

      if (_isValidMatrixFuncCombination(matrixFunction1, matrixFunction2) &&
          _isValidMatrixFunction(matrixFunction1, input[1].replaceAll("&", "")) &&
          _isValidMatrixFunction(matrixFunction2, input[4].replaceAll("&", "")) &&
          _validateOperator(operator) &&
          _validateMatrixFuncSize(matrixFunction1, matrixFunction2, input[1], input[4], operator) &&
          _checkValues(matrix1Values) && _checkValues(matrix2Values)) {
        valid = true;
        _createValidMatrixExp(operator, matrixFunction1, input[1], matrixFunction2, input[4]);
      }
    }

    return valid;
  }

  bool _checkValues(List<String> matrix1Values){
    for(int i = 0; i < matrix1Values.length; i++){
      String token = validate.sanitizeToken(matrix1Values[i]);

      if(_isMathFunction(token)){
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

  bool _validateOperator(String value){
    if(Pattern.validOperator.hasMatch(value))
      return true;
    else
      return false;
  }

  bool _validateSize(String matrix1, String matrix2, String operator){
    bool valid = false;

    if(Pattern.addSubtractOperator.hasMatch(operator) && _isRowSameSize(matrix1, matrix2)
        && _isColumnSameSize(matrix1, matrix2)){
      valid = true;
    }
    else if(Pattern.multiplyDivideOperator.hasMatch(operator) && _isRowColSameSize(matrix1, matrix2)){
      valid = true;
    }

    return valid;
  }

  bool _isRowSameSize(String matrix1, String matrix2){
    return _getRowsMatrix(matrix1).length == _getRowsMatrix(matrix2).length;
  }

  bool _isColumnSameSize(String matrix1, String matrix2){
    List<String> rowsMatrix1 = _getRowsMatrix(matrix1);
    List<String> rowsMatrix2 = _getRowsMatrix(matrix2);
    bool valid = false;

    //need to check if correct number of columns exist in a row for matrix
    if(_isValidColumns(rowsMatrix1) && _isValidColumns(rowsMatrix2)) {
      List<String> colMatrix1 = rowsMatrix1[0].split(";");
      List<String> colMatrix2 = rowsMatrix2[0].split(";");

      if (colMatrix1.length == colMatrix2.length)
        valid = true;
    }

    return valid;
  }

  bool _isRowColSameSize(String matrix1, String matrix2){
    List<String> rowsMatrix2 = _getRowsMatrix(matrix2);
    List<String> rowsMatrix1 = _getRowsMatrix(matrix1);
    bool valid = false;

    //need to check if correct number of columns exist in a row for matrix
    if(_isValidColumns(rowsMatrix1) && _isValidColumns(rowsMatrix2)) {
      List<String> colMatrix1 = rowsMatrix1[0].split(";");

      if (rowsMatrix2.length == colMatrix1.length)
        valid = true;
    }

    return valid;
  }

  bool _isValidColumns(List<String> rowsMatrix){
    int colSize = rowsMatrix[0].split(";").length;

    for (int i=0; i < rowsMatrix.length; i++) {
      List<String> colMatrix = rowsMatrix[i].split(";");
      if (colSize != colMatrix.length)
        return false;
    }

    return true;
  }

  bool _isMathFunction(String input){
    bool checker = false;

    if(InputTokens.specialOperators.any((element) => input.contains(element)) ||
        InputTokens.validFunctions.any((element) => input.contains(element)) ||
        InputTokens.multiParamFunctions.any((element) => input.contains(element)))
      checker = true;

    return checker;
  }

  bool _isValidMatrixFuncCombination(String matrixFunction1, String matrixFunction2){
    return (_isMatrixReturnMatrixFunction(matrixFunction1) && _isMatrixReturnMatrixFunction(matrixFunction2)) ||
      (_isMatrixReturnValuesFunction(matrixFunction1) && _isMatrixReturnValuesFunction(matrixFunction2));
  }

  bool _isValidMatrixFunction(String matrixFunction, String matrix){
    bool checker = false;

    if(_isMatrixReturnValuesFunction(matrixFunction)){
      checker = true;
    }
    else if (_isMatrixReturnMatrixFunction(matrixFunction)){
      //handle special case check for 'rref'
      if(matrixFunction == "rref") {
        int rowSizeMatrix = _getRowsMatrix(matrix).length;
        int colSizeMatrix = _getRowsMatrix(matrix)[0].split(";").length;
        if((colSizeMatrix == (rowSizeMatrix + 1)))
          checker = true;
      }
      else
        checker = true;
    }

    return checker;
  }

  bool _isMatrixReturnMatrixFunction(String matrixFunction){
    bool checker = false;
    String token = validate.sanitizeToken(matrixFunction);

    if(InputTokens.matrixReturnMatrixFunctions.any((element) => token.compareTo(element)==0) ||
        Pattern.validMatrixOperand.hasMatch(token))
      checker = true;

    return checker;
  }

  bool _isMatrixReturnValuesFunction(String matrixFunction){
    bool checker = false;

    if(InputTokens.matrixReturnValuesFunctions.any((element) => element.contains(matrixFunction)))
      checker = true;

    return checker;
  }

  bool _isMatrix(String value){
    if(value.startsWith("&") && value.endsWith("@"))
      return true;
    else
      return false;
  }

  List<String> _getRowsMatrix(String matrix){
    return matrix.split("@").where((item) => item.isNotEmpty).toList();
  }

  List<String> _getMatrixValues(String input){
    return input.replaceAll("&", "").
      split(RegExp(r'(@|;)')).where((item) => item.isNotEmpty).toList();
  }

  String _createTmpMatrix(int row, int col){
    String matrix = "";
    for(int r = 0; r < row; r++){
      for(int c = 0; c < col; c++) {
          matrix += "1;";
      }
      matrix += "@";
    }

    // cleanup matrix string format
    matrix = matrix.replaceAll(";@", "@");

    return matrix;
  }

  void _createValidMatrixExp(String operator, String matrixFunc1, String matrix1,
    String matrixFunc2, String matrix2){
    validMatrixExpression.insert(0, operator);

    //if scalar value, add expressions at correct index
    if(Pattern.validMatrixOperand.hasMatch(validate.sanitizeToken(matrixFunc1)))
      validMatrixExpression.insert(1, "");
    //if matrixFunc, add expressions at correct index
    else
      validMatrixExpression.insert(1, matrixFunc1);

    validMatrixExpression.insert(2, matrix1);

    if(Pattern.validMatrixOperand.hasMatch(validate.sanitizeToken(matrixFunc2)))
      validMatrixExpression.insert(3, "");
    else
      validMatrixExpression.insert(3, matrixFunc2);

    validMatrixExpression.insert(4, matrix2);

    if(Pattern.validMatrixOperand.hasMatch(validate.sanitizeToken(matrixFunc1)))
      validMatrixExpression.insert(5, matrixFunc1);
    else
      validMatrixExpression.insert(5, "");

    if(Pattern.validMatrixOperand.hasMatch(validate.sanitizeToken(matrixFunc2)))
      validMatrixExpression.insert(6, matrixFunc2);
    else
      validMatrixExpression.insert(6, "");
  }

  bool _validateMatrixFuncSize(String matrixFunction1, String matrixFunction2,
      String matrix1, String matrix2, String operator){
    bool checker = false;
    String updatedMatrix1 = "";
    int rowSizeMatrix1 = _getRowsMatrix(matrix1).length;
    int colSizeMatrix1 = _getRowsMatrix(matrix1)[0].split(";").length;
    int rowSizeMatrix2 = _getRowsMatrix(matrix2).length;
    int colSizeMatrix2 = _getRowsMatrix(matrix2)[0].split(";").length;

    if(_isMatrixReturnMatrixFunction(matrixFunction1) && _isMatrix(matrix2)){
      updatedMatrix1 = _createTmpMatrix(colSizeMatrix1, rowSizeMatrix1);
      // Case for input list size = 5
      // eg: transpose (matrix1) + transpose (matrix2)
      if(matrixFunction2.isNotEmpty || matrixFunction2 != null){
        String updatedMatrix2 = _createTmpMatrix(colSizeMatrix2, rowSizeMatrix2);
        if(_validateSize(updatedMatrix1, updatedMatrix2, operator))
          checker = true;
      }
      // Case for input list size = 4
      // eg: transpose (matrix1) + matrix2
      else {
        if(_validateSize(updatedMatrix1, matrix2.replaceAll("&", ""), operator))
          checker = true;
      }
    }
    // Case for input list size = 4
    // eg: determinant (matrix1) + 2
    // eg. 2 + determinant (matrix2)
    else if(_isMatrixReturnValuesFunction(matrixFunction1) && !(_isMatrix(matrix2))
        && (colSizeMatrix1 == rowSizeMatrix1)){
      checker = true;
    }
    // Case for input list size = 5
    // eg. determinant (matrix1) + permanent (matrix2)
    else if(_isMatrixReturnValuesFunction(matrixFunction1) && _isMatrix(matrix2) &&
        _isMatrixReturnValuesFunction(matrixFunction2) && (colSizeMatrix1 == rowSizeMatrix1) &&
        (colSizeMatrix2 == rowSizeMatrix2)){
      checker = true;
    }

    return checker;
  }

  bool _sanitizeMatrixFunction(String matrixFunction, String matrix){
    bool checker = false;
    // split for special leftover case: value + function
    if(InputTokens.matrixOperators.any((element) => matrixFunction.contains(element))){
      String expression = matrixFunction;
      expression = expression.replaceAll("+", " + ");
      expression = expression.replaceAll("-", " - ");
      expression = expression.replaceAll("*", " * ");
      expression = expression.replaceAll("/", " / ");

      List<String> values = expression.split(TranslatePattern.spacing).
        where((item) => item.isNotEmpty).toList();

      specialMatrixFunction = values[2];
      String operator = values[1];
      String operand = validate.sanitizeToken(values[0]);
      if(_isMatrixReturnMatrixFunction(specialMatrixFunction) &&
          !(Pattern.validMatrixOperand.hasMatch(operand)))
        checker = true;
      else if (_isMatrixReturnValuesFunction(specialMatrixFunction) &&
          Pattern.validMatrixOperand.hasMatch(operand))
        checker = true;

      _createValidMatrixExp(operator, "", operand, specialMatrixFunction, matrix);
    }
    else {
      specialMatrixFunction = matrixFunction;
      checker = true;
      _createValidMatrixExp("", matrixFunction, matrix, "", "");
    }

    return checker;
  }

  List<String> sanitizeMatrixInput(String input){
    // perform input replacements to support simplification
    input = input.replaceAll("(&", " &");
    input = input.replaceAll("\$)", "\$");
    input = input.replaceAll("\$+", "\$ + ");
    input = input.replaceAll("\$-", "\$ - ");
    input = input.replaceAll("\$*", "\$ * ");
    input = input.replaceAll("\$/", "\$ / ");
    // replace dollar signs for consistent validation check
    input = input.replaceAll("\$+&", "@ + &");
    input = input.replaceAll("\$-&", "@ - &");
    input = input.replaceAll("\$*&", "@ * &");
    input = input.replaceAll("\$/&", "@ / &");
    input = input.replaceAll("\$", "@");

    List<String> sanitizedInput = input.split(TranslatePattern.spacing).
      where((item) => item.isNotEmpty).toList();

    return sanitizedInput;
  }
}