
class Pattern {

  RegExp add = new RegExp(r"\s*\+\s*");
  RegExp subtract = new RegExp(r"\s*−\s*");
  RegExp divide = new RegExp(r"\s*\*\s*");
  RegExp multiply = new RegExp(r"\s*/\s*");
  RegExp openParen = new RegExp(r"\(");
  RegExp closeParen = new RegExp(r"\)");
  RegExp numberX = new RegExp(r'([0-9]+|[𝜋𝑒])([a-z]+)', unicode: true);
  RegExp numberParen = new RegExp(r'([0-9]+|[𝜋𝑒])(\()', unicode: true);
  RegExp numberConst = new RegExp(r'([0-9]+|[𝜋𝑒])([𝜋𝑒])', unicode: true);

  // RegExp numberX = new RegExp(r'([0-9]+|[\u{1D70B}\u{1D452}])([a-z]+)');
  // RegExp numberParen = new RegExp(r'([0-9]+|[\u{1D70B}\u{1D452}])(\()');
  // RegExp numberConst = new RegExp(r'([0-9]+|[\u{1D70B}\u{1D452}])([\u{1D70B}\u{1D452}])');



  static final Pattern _singleton = Pattern._internal();
  factory Pattern() {
    return _singleton;
  }
  Pattern._internal();
}

class Translator {
  Pattern patterns = Pattern();

// translates display values of a calculator expressions into proper format for processing
  String translate(String input) {
    String translated;
    if (input == null) return input;
    translated = _handleNegatives(input);
    translated = _addImpliedMultiply(translated);
    translated = _fixSpacing(translated);
    translated = _addClosingParentheses(translated);
    return translated.trim();
  }

  // corrects the expression's spacing regardless of previous whitespace
  String _fixSpacing(String input) {
    String result;
    result = input. replaceAll(patterns.add, " + ");
    result = result.replaceAll(patterns.subtract, " - ");
    result = result.replaceAll(patterns.divide, " * ");
    result = result.replaceAll(patterns.multiply, " / ");
    result = result.replaceAll("^", " ^ ");
    result = result.replaceAll("(", " ( ");
    result = result.replaceAll(")", " ) ");
    result = result.replaceAll("²", " ^ 2 ");
    result = result.replaceAll("⁻¹", " ^ -1 ");
    result = result.replaceAll("ln(", "ln ( " );
    result = result.replaceAll("sin(", "sin ( ");
    result = result.replaceAll("cos(", "cos ( ");
    result = result.replaceAll("tan(", "tan ( ");
    result = result.replaceAll("log(", "log ( ");
    return result;
  }

  // append missing closing parentheses
  String _addClosingParentheses(String input) {
    String result = input.trim() + " ";  // add ending space
    var openingMatches = patterns.openParen.allMatches(input);
    var closingMatches = patterns.closeParen.allMatches(input);
    for (var i = 0; i < openingMatches.length - closingMatches.length; i++) {
      result += ") ";
    }
    return result;
  }

  // change all tokens such as '3sin' into '3 * sin' and '3(' to '3 * ('
  String _addImpliedMultiply(String input) {
    String result = input;
    for (var i = 0; i < 2; i++) {  // runs twice for overlapping matches
      result = result.replaceAllMapped(patterns.numberX, (Match m) {
        return "${m.group(1)} * ${m.group(2)}";
      });
      result = result.replaceAllMapped(patterns.numberParen, (Match m) {
        return "${m.group(1)} * ${m.group(2)}";
      });
      result = result.replaceAllMapped(patterns.numberConst, (Match m) {
        return "${m.group(1)} * ${m.group(2)}";
      });
    }
    return result;
  }

  String _handleNegatives(String input) {
    return input.replaceAll("-", " -1 * ");
  }

  // translate matrix expression such as 'Matrix1+Matrix2'
  String translateMatrix(String input) {
    String translated;
    translated = input. replaceAll(patterns.add, " + ");
    translated = translated.replaceAll(patterns.subtract, " - ");
    translated = translated.replaceAll(patterns.divide, " * ");
    translated = translated.replaceAll(patterns.multiply, " / ");
    return translated;
  }

}