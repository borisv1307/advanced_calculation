import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef RawGraphCalculateFunction = Double Function(Pointer<Utf8>, Double x);
typedef GraphCalculateFunction = double Function(Pointer<Utf8>, double x);

typedef RawCalculateFunction = Double Function(Pointer<Utf8>);
typedef CalculateFunction = double Function(Pointer<Utf8>);

// Parameters: operator, matrixFunction1, matrix1, matrixFunction2, matrix2, scalar1, scalar2
typedef RawMatrixFunction = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>,
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Double x, Double y);
typedef MatrixFunction = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>,
    Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>,double x, double y);

class LibraryLoader{
  static const FILE_NAME = "libcalc.so";
  final DynamicLibrary library;
  
  LibraryLoader():
    this.library = Platform.isAndroid
        ?  DynamicLibrary.open(FILE_NAME)
        : DynamicLibrary.process();

  GraphCalculateFunction loadGraphCalculateFunction(){
     GraphCalculateFunction calculateFunction =  library
         .lookup<NativeFunction<RawGraphCalculateFunction>>("calculate_for_graph")
         .asFunction();

     return calculateFunction;
  }

  CalculateFunction loadCalculateFunction() {
    CalculateFunction calculateFunction = library
        .lookup<NativeFunction<RawCalculateFunction>>("calculate")
        .asFunction<CalculateFunction>();

    return calculateFunction;
  }

  MatrixFunction loadMatrixFunction() {
    MatrixFunction matrixFunction;
    try{
      matrixFunction = library
          .lookup<NativeFunction<RawMatrixFunction>>("matrix_call")
          .asFunction();
    }on ArgumentError{

    }

    
    return matrixFunction;
  }
}