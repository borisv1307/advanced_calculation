import 'package:advanced_calculation/src/input_validation/validate_matrix_function.dart';
import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi';

class MatrixCalculator{
  MatrixFunction matrixFunction;
  Translator translator;
  ValidateMatrixFunction tester;

  MatrixCalculator() {
    matrixFunction = getLibraryLoader().loadMatrixFunction();
    translator = Translator();
    tester = ValidateMatrixFunction();

  }

  LibraryLoader getLibraryLoader(){
    return LibraryLoader();
  }

  String calculate(String input){
    bool validExpression = tester.testMatrixFunction(input);
    if(validExpression) {
      String expression = translator.translateMatrixExpr(input);
      List<String> tokens = expression.split(" ");
      Pointer<Utf8> resultPtr = matrixFunction(
          Utf8.toUtf8(tokens[0]), Utf8.toUtf8(tokens[2]),
          Utf8.toUtf8(tokens[1]));
      return Utf8.fromUtf8(resultPtr);
    }
    else
      return "Syntax Error";
  }
}
