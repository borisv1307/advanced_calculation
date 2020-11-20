import 'package:advanced_calculation/src/library_loader.dart';
import 'package:advanced_calculation/src/translator/translator.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi';

class MatrixCalculator{
  MatrixFunction matrixFunction;
  Translator translator;

  MatrixCalculator() {
    matrixFunction = getLibraryLoader().loadMatrixFunction();
    translator = Translator();
  }

  LibraryLoader getLibraryLoader(){
    return LibraryLoader();
  }

  String calculate(String input){
    String expression = translator.translateMatrix(input);
    // TODO: validation
    List<String> tokens = expression.split(" ");
    Pointer<Utf8> resultPtr = matrixFunction(Utf8.toUtf8(tokens[0]), Utf8.toUtf8(tokens[2]), Utf8.toUtf8(tokens[1]));
    return Utf8.fromUtf8(resultPtr);

  }
}
