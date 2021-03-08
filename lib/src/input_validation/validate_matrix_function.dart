import 'package:advanced_calculation/src/helper/negative_helper.dart';
import 'package:advanced_calculation/src/input_validation/input_tokens.dart';
import 'package:advanced_calculation/src/input_validation/validate_function.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/helper/matrix_helper.dart';

class ValidateMatrixFunction {
  MatrixHelper helper = MatrixHelper();
  NegativeHelper negativesHelper = NegativeHelper();
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
      List<String> matrix1Values = helper.getMatrixValues(input[1]);

      if(_sanitizeMatrixFunction(matrixFunction, input[1]) &&
          _isValidMatrixFunction(specialMatrixFunction, input[1].replaceAll("&", "")) &&
          _checkValues(matrix1Values))
        valid = true;
    }
    // Case: matrix operation matrix
    // eg: matrix1 + matrix2
    else if(inputSize == 3){
      List<String> matrix1Values = helper.getMatrixValues(input[0]);
      String operator = input[1];
      List<String> matrix2Values = helper.getMatrixValues(input[2]);

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
        List<String> matrix1Values = helper.getMatrixValues(input[1]);
        String operator = input[2];
        List<String> matrix2Values = helper.getMatrixValues(input[3]);

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
        List<String> matrix1Values = helper.getMatrixValues(input[0]);
        String operator = input[1];
        String matrixFunction = input[2];
        List<String> matrix2Values = helper.getMatrixValues(input[3]);

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
      List<String> matrix1Values = helper.getMatrixValues(input[1]);
      String operator = input[2];
      String matrixFunction2 = input[3];
      List<String> matrix2Values = helper.getMatrixValues(input[4]);

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
      String token = negativesHelper.sanitizeToken(matrix1Values[i]);

      if(helper.isMathFunction(token)){
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

    if(Pattern.addSubtractOperator.hasMatch(operator) && helper.isRowSameSize(matrix1, matrix2)
        && helper.isColumnSameSize(matrix1, matrix2)){
      valid = true;
    }
    else if(Pattern.multiplyDivideOperator.hasMatch(operator) && helper.isRowColSameSize(matrix1, matrix2)){
      valid = true;
    }

    return valid;
  }

  bool _isValidMatrixFuncCombination(String matrixFunction1, String matrixFunction2){
    return (helper.isMatrixReturnMatrixFunction(matrixFunction1) && helper.isMatrixReturnMatrixFunction(matrixFunction2)) ||
      (helper.isMatrixReturnValuesFunction(matrixFunction1) && helper.isMatrixReturnValuesFunction(matrixFunction2));
  }

  bool _isValidMatrixFunction(String matrixFunction, String matrix){
    bool checker = false;

    if(helper.isMatrixReturnValuesFunction(matrixFunction)){
      checker = true;
    }
    else if (helper.isMatrixReturnMatrixFunction(matrixFunction)){
      //handle special case check for 'reduced_row_echelon'
      if(matrixFunction == "reduced_row_echelon") {
        int rowSizeMatrix = helper.getRowsMatrix(matrix).length;
        int colSizeMatrix = helper.getRowsMatrix(matrix)[0].split(";").length;
        if((colSizeMatrix == (rowSizeMatrix + 1)))
          checker = true;
      }
      else
        checker = true;
    }

    return checker;
  }

  void _createValidMatrixExp(String operator, String matrixFunc1, String matrix1,
    String matrixFunc2, String matrix2){
    validMatrixExpression.insert(0, operator);

    //if scalar value, add expressions at correct index
    if(Pattern.validMatrixOperand.hasMatch(negativesHelper.sanitizeToken(matrixFunc1)))
      validMatrixExpression.insert(1, "");
    //if matrixFunc, add expressions at correct index
    else
      validMatrixExpression.insert(1, matrixFunc1);

    validMatrixExpression.insert(2, matrix1);

    if(Pattern.validMatrixOperand.hasMatch(negativesHelper.sanitizeToken(matrixFunc2)))
      validMatrixExpression.insert(3, "");
    else
      validMatrixExpression.insert(3, matrixFunc2);

    validMatrixExpression.insert(4, matrix2);

    if(Pattern.validMatrixOperand.hasMatch(negativesHelper.sanitizeToken(matrixFunc1)))
      validMatrixExpression.insert(5, matrixFunc1);
    else
      validMatrixExpression.insert(5, "");

    if(Pattern.validMatrixOperand.hasMatch(negativesHelper.sanitizeToken(matrixFunc2)))
      validMatrixExpression.insert(6, matrixFunc2);
    else
      validMatrixExpression.insert(6, "");

    // if matrix or value, matrix is not empty
    if(matrix2.isNotEmpty)
      validMatrixExpression.insert(7, "false");
    else
      validMatrixExpression.insert(7, "true");
  }

  bool _validateMatrixFuncSize(String matrixFunction1, String matrixFunction2,
      String matrix1, String matrix2, String operator){
    bool checker = false;
    String updatedMatrix1 = "";
    int rowSizeMatrix1 = helper.getRowsMatrix(matrix1).length;
    int colSizeMatrix1 = helper.getRowsMatrix(matrix1)[0].split(";").length;
    int rowSizeMatrix2 = helper.getRowsMatrix(matrix2).length;
    int colSizeMatrix2 = helper.getRowsMatrix(matrix2)[0].split(";").length;

    if(helper.isMatrixReturnMatrixFunction(matrixFunction1) && helper.isMatrix(matrix2)){
      updatedMatrix1 = helper.createTmpMatrix(colSizeMatrix1, rowSizeMatrix1);
      // Case for input list size = 5
      // eg: transpose (matrix1) + transpose (matrix2)
      if(matrixFunction2.isNotEmpty || matrixFunction2 != null){
        String updatedMatrix2 = helper.createTmpMatrix(colSizeMatrix2, rowSizeMatrix2);
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
    else if(helper.isMatrixReturnValuesFunction(matrixFunction1) && !(helper.isMatrix(matrix2))
        && (colSizeMatrix1 == rowSizeMatrix1)){
      checker = true;
    }
    // Case for input list size = 5
    // eg. determinant (matrix1) + permanent (matrix2)
    else if(helper.isMatrixReturnValuesFunction(matrixFunction1) && helper.isMatrix(matrix2) &&
        helper.isMatrixReturnValuesFunction(matrixFunction2) && (colSizeMatrix1 == rowSizeMatrix1) &&
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
      String operand = negativesHelper.sanitizeToken(values[0]);
      if(helper.isMatrixReturnMatrixFunction(specialMatrixFunction) &&
          !(Pattern.validMatrixOperand.hasMatch(operand)))
        checker = true;
      else if (helper.isMatrixReturnValuesFunction(specialMatrixFunction) &&
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