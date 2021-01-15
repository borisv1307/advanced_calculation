import 'package:advanced_calculation/src/parse/expression_parser.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';

class Translator {
  ExpressionParser parser = ExpressionParser();
  List<RegExp> impliedMultiplyPatterns = [TranslatePattern.numberX, TranslatePattern.xNumber,
    TranslatePattern.numberParen, TranslatePattern.xAdj, TranslatePattern.powerX];

// translates display values of a calculator expressions into proper format for processing
  String translate(String input) {
    String translated;
    if (input == null) return input;
    translated = _handleNegatives(input);
    translated = _addImpliedMultiply(translated);
    translated = _convertSymbols(translated);
    translated = parser.padTokens(translated);
    translated = _handleX(translated);
    translated = _addClosingParentheses(translated);
    return translated.trim();
  }

  String _convertSymbols(String input){
    String result = input.replaceAll(" ²", " ^ 2 ");
    result = result.replaceAll("²", " ^ 2 ");
    result = result.replaceAll("⁻¹", " ^ -1 ");
    result = result.replaceAll("√", "sqrt");
    result = result.replaceAll("−", "-");

    return result;
  }

  // must occur after adding implied multiply
  String _handleX(String input){ 
    return input.replaceAll("𝑥", "x");
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
      impliedMultiplyPatterns.forEach((pattern) {
        result = result.replaceAllMapped(pattern, (Match m) {
          return "${m.group(1)} * ${m.group(2)}";
        });
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
    translated = input.replaceAll("+", " + ");
    translated = translated.replaceAll("−", " − ");
    translated = translated.replaceAll("*", " * ");
    translated = translated.replaceAll("/", " / ");
    return translated;
  }

}