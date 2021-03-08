import 'package:advanced_calculation/src/helper/negative_helper.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/input_validation/input_tokens.dart';

class MatrixHelper {
  MatrixHelper();

  bool isRowSameSize(String matrix1, String matrix2){
    return getRowsMatrix(matrix1).length == getRowsMatrix(matrix2).length;
  }

  bool isColumnSameSize(String matrix1, String matrix2){
    List<String> rowsMatrix1 = getRowsMatrix(matrix1);
    List<String> rowsMatrix2 = getRowsMatrix(matrix2);
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
    List<String> rowsMatrix2 = getRowsMatrix(matrix2);
    List<String> rowsMatrix1 = getRowsMatrix(matrix1);
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

  bool isMatrixReturnMatrixFunction(String matrixFunction){
    bool checker = false;
    String token = NegativeHelper().sanitizeToken(matrixFunction);

    if(InputTokens.matrixReturnMatrixFunctions.any((element) => token.compareTo(element)==0) ||
        Pattern.validMatrixOperand.hasMatch(token))
      checker = true;

    return checker;
  }

  bool isMatrixReturnValuesFunction(String matrixFunction){
    bool checker = false;

    if(InputTokens.matrixReturnValuesFunctions.any((element) => element.contains(matrixFunction)))
      checker = true;

    return checker;
  }

  bool isMatrix(String value){
    if(value.startsWith("&") && value.endsWith("@"))
      return true;
    else
      return false;
  }

  List<String> getRowsMatrix(String matrix){
    return matrix.split("@").where((item) => item.isNotEmpty).toList();
  }

  List<String> getMatrixValues(String input){
    return input.replaceAll("&", "").
      split(RegExp(r'(@|;)')).where((item) => item.isNotEmpty).toList();
  }

  // returns the Matrix size as a list of [row, col]
  List<int> matrixSize(String sanitizedInput){
    List<String> matrixRow = sanitizedInput.replaceAll(RegExp(r'(&|\$)'), "").
    split("@").where((item) => item.isNotEmpty).toList();
    int matrixRowSize = matrixRow.length;
    int matrixColSize = matrixRow[0].split(";").where((item) => item.isNotEmpty).toList().length;
    List<int> matrixSize = [matrixRowSize, matrixColSize];

    return matrixSize;
  }

  String createTmpMatrix(int row, int col){
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
}