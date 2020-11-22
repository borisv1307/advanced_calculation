import 'package:advanced_calculation/src/translator/translate_pattern.dart';

class Translator {

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
    result = input. replaceAll("+", " + ");
    result = result.replaceAll("−", " - ");
    result = result.replaceAll("*", " * ");
    result = result.replaceAll("/", " / ");
    result = result.replaceAll("^", " ^ ");
    result = result.replaceAll("(", " ( ");
    result = result.replaceAll(")", " ) ");
    result = result.replaceAll("²", " ^ 2 ");
    result = result.replaceAll("⁻¹", " ^ -1 ");
    result = result.replaceAll("√", "sqrt");
    result = result.replaceAll(TranslatePattern.spacing, " ");
    return result;
  }

  // append missing closing parentheses
  String _addClosingParentheses(String input) {
    String result = input.trim() + " ";  // add ending space
    var openingMatches = TranslatePattern.openParen.allMatches(input);
    var closingMatches = TranslatePattern.closeParen.allMatches(input);
    for (var i = 0; i < openingMatches.length - closingMatches.length; i++) {
      result += ") ";
    }
    return result;
  }

  // change all tokens such as '3sin' into '3 * sin' and '3(' to '3 * ('
  String _addImpliedMultiply(String input) {
    String result = input;
    for (var i = 0; i < 2; i++) {  // runs twice for overlapping matches
      result = result.replaceAllMapped(TranslatePattern.numberX, (Match m) {
        return "${m.group(1)} * ${m.group(2)}";
      });
      result = result.replaceAllMapped(TranslatePattern.numberParen, (Match m) {
        return "${m.group(1)} * ${m.group(2)}";
      });
      result = result.replaceAllMapped(TranslatePattern.numberConst, (Match m) {
        return "${m.group(1)} * ${m.group(2)}";
      });
    }
    return result;
  }

  String _handleNegatives(String input) {
    return input.replaceAll("-", " -1 * ");
  }

  // translate matrix expression such as 'Matrix1+Matrix2'
  String translateMatrixExpr(String input) {
    String translated;
    translated = input. replaceAll("+", " + ");
    translated = translated.replaceAll("−", " − ");
    translated = translated.replaceAll("*", " * ");
    translated = translated.replaceAll("/", " / ");
    return translated;
  }

}