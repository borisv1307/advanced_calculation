import 'package:advanced_calculation/src/translator/translate_pattern.dart';

class ExpressionParser{
  String padTokens(String expression){
      String result;
      result = expression. replaceAll("+", " + ");
      result = result.replaceAll("−", " − ");
      result = result.replaceAll("*", " * ");
      result = result.replaceAll("/", " / ");
      result = result.replaceAll("^", " ^ ");
      result = result.replaceAll("(", " ( ");
      result = result.replaceAll(")", " ) ");
      result = result.replaceAll(",", " , ");
      result = result.replaceAll(TranslatePattern.spacing, " ");
      return result;
  }
}