import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/start_state.dart';
import 'package:advanced_calculation/src/input_validation/state.dart';
import 'open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';

class ValidateFunction {
  State currentState;
  bool isMultiParam = false;
  int multiParamCounter = 0; // Considers counting '(' for math functions with more than parameter
  int counter = 0; // Considers counting '(' for math functions with 1 parameter
  static final List<String> lengthTwoFunc = ["ln"];
  static final List<String> lengthThreeFunc = ["log","sin","cos","tan", "abs", "csc","sec", "cot" ];
  static final List<String> lengthFourFunc = ["sqrt", "sinh", "cosh", "tanh", "asin", "acos", "atan", "acsc", "asec", "acot", "csch", "sech", "coth", "ceil"];
  static final List<String> lengthFiveFunc = ["asinh", "acosh", "atanh", "acsch", "asech", "acoth", "floor", "round", "trunc", "fract"];
  static final List<String> lengthThreeMultiParamFunc = ["max", "min", "gcd", "lcm"];

  ValidateFunction(){
    currentState= new StartState(this);
  }

  void setCurrentState(State currentState) {
    this.currentState = currentState;
  }

  State getCurrentState() {
    return currentState;
  }

  List<String> initialize(String input){
    this.counter = 0;
    this.multiParamCounter = 0;
    isMultiParam = false;
    input = input + " = ";
    List<String> inputString = input.split(" ");

    for(int i = 0; i < inputString.length; i++){
      if(inputString[i].isEmpty){
        inputString.removeAt(i);
      }
    }

    return inputString;
  }

  void incrementCounter(){
    if(isMultiParam)
      this.multiParamCounter = this.multiParamCounter + 1;
    else
      this.counter = this.counter + 1;
  }

  bool testFunction(String input) {
    List<String> inputString = initialize(input);
    currentState= new StartState(this);

    for(int i = 0; i < inputString.length; i++) {
      //handle special negatives for complex functions
      if(RegExp(r'^-[a-z]+$').hasMatch(inputString[i]) && inputString[i].length > 1) {
        inputString[i] = inputString[i].substring(1); // remove the negative
      }

      if(Pattern.validOperand.hasMatch(inputString[i]) || inputString[i].length == 1) {  // numbers or operands
        if(this.isMultiParam)
          this.multiParamCounter = currentState.getNextState(inputString[i], multiParamCounter, isMultiParam);
        else
          this.counter = currentState.getNextState(inputString[i], counter, isMultiParam);

        if(currentState is ErrorState)
          return false;
      }
      else if(inputString[i].length == 2) {
        if(inputString[i] == "-(") {
          // handle expression special case and Increment the counter and update state
          incrementCounter();
          currentState = new OpenSubExpressionState(this);
        }
        else if(lengthTwoFunc.contains(inputString[i]) == false)
          return false;
      }
      else if(inputString[i].length == 3) {
        if(!lengthThreeFunc.contains(inputString[i]) && !lengthThreeMultiParamFunc.contains(inputString[i]) )
          return false;
        else if(lengthThreeMultiParamFunc.contains(inputString[i]))
          isMultiParam = true;
      }
      else if(inputString[i].length == 4) {
        if(lengthFourFunc.contains(inputString[i]) == false)
          return false;
      }
      else if(inputString[i].length == 5) {
        if(lengthFiveFunc.contains(inputString[i]) == false)
          return false;
      }
      else
        return false;
    }

    return true;
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
      if(!Pattern.validOperand.hasMatch(matrix1Values[i]))
        return false;
    }

    for(int i = 0; i < matrix2Values.length; i++){
      if(!Pattern.validOperand.hasMatch(matrix2Values[i]))
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
