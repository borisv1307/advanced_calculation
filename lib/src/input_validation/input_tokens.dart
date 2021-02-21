class InputTokens{
  static final List<String> validFunctions = ["ln","log","abs", "sqrt", "ceil", "floor", "round", "trunc", "fract", "√", '`'] + trigFunctions;
  static final List<String> multiParamFunctions = ["max", "min", "gcd", "lcm"];
  static final List<String> operators = ['*','/','-','+','(',')','^',',','²','⁻¹'];
  static final List<String> symbols = ['𝜋', '𝑒', '𝑥'];
  static final List<String> specialOperators = ['(',')','^','²','⁻¹'];
  static final List<String> trigFunctions = ["sin","cos","tan", "sec", "csc", "cot", "sinh", "cosh", "tanh", "sech", "csch", "coth",
    "asin", "acos", "atan", "asec", "acsc", "acot","acoth","asinh", "acosh", "atanh", "acsch", "asech"];
  static final List<String> matrixReturnMatrixFunctions = ["transpose", "rref"];
  static final List<String> matrixReturnValuesFunctions = ["determinant", "permanent"];
  static final List<String> matrixOperators = ['*','/','-','+'];
}