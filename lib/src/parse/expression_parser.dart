import 'package:advanced_calculation/src/input_validation/input_tokens.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';

class ExpressionParser{

  List<String> tokens = InputTokens.operators + InputTokens.symbols;

  String padTokens(String expression){
      String result = expression;
      tokens.forEach((token) {
        result = result.replaceAll(token, ' ' + token + ' ');
      });

      result = result.replaceAll(TranslatePattern.spacing, " ");
      return result;
  }
}