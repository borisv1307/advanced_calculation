class InputTokens{
  static final List<String> validFunctions = ["ln","log","sin","cos","tan", "abs", "csc","sec", "cot", "sqrt", "sinh", "cosh", "tanh",
    "asin", "acos", "atan", "acsc", "asec", "acot", "csch", "sech", "coth", "ceil","asinh", "acosh", "atanh", "acsch", "asech",
    "acoth", "floor", "round", "trunc", "fract", "√", '`'];
  static final List<String> multiParamFunctions = ["max", "min", "gcd", "lcm"];
  static final List<String> operators = ['*','/','-','+','(',')','^',',','²','⁻¹'];
  static final List<String> symbols = ['𝜋', '𝑒', '𝑥'];
  static final List<String> specialOperators = ['(',')','^','²','⁻¹'];
}