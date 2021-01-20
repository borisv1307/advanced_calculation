import 'package:advanced_calculation/src/input_validation/error_state.dart';
import 'package:advanced_calculation/src/input_validation/input_tokens.dart';
import 'package:advanced_calculation/src/input_validation/open_subexpression_state.dart';
import 'package:advanced_calculation/src/input_validation/pattern.dart';
import 'package:advanced_calculation/src/parse/expression_parser.dart';
import 'package:advanced_calculation/src/translator/translate_pattern.dart';
import 'start_state.dart';
import 'state.dart';

class ValidateFunction {
  ExpressionParser parser = ExpressionParser();

  List<String> _sanitizeInput(String input){
    List<String> sanitizedInput = parser.padTokens(input).split(TranslatePattern.spacing).where((item) => item.isNotEmpty).toList();

    return sanitizedInput;
  }

  String sanitizeToken(String token){
    String sanitizedToken = token;
    //handle special negatives for complex functions
    while(sanitizedToken.startsWith('`') && sanitizedToken.length > 1) {
      sanitizedToken = sanitizedToken.substring(1); // remove the negatives
    }

    return sanitizedToken;
  }

  int findSyntaxError(String input) {
    int invalidTokenIndex = -1;
    List<String> inputString = _sanitizeInput(input);
    State currentState = StartState(0, false);

    for(int i=0;(i<inputString.length && invalidTokenIndex == -1);i++) {
      String token = sanitizeToken(inputString[i]);

      if (InputTokens.operators.contains(token) ||
          Pattern.validOperand.hasMatch(token)) { // numbers or operands
        currentState = currentState.getNextState(token);
      } else if (InputTokens.multiParamFunctions.contains(token)) {
        currentState.multiParam = true;
      } else if(!InputTokens.validFunctions.any((function) => token.endsWith(function))) {
        invalidTokenIndex =  i;
      }

      if(currentState is ErrorState) {
        invalidTokenIndex = i;
      }
    }

    if(currentState is OpenSubExpressionState){
      invalidTokenIndex = inputString.length - 1;
    }else if(currentState is StartState){
      invalidTokenIndex = 0;
    }

    int invalidIndex = _convertTokenIndex(invalidTokenIndex, inputString);

    return invalidIndex;
  }

  int _convertTokenIndex(int tokenIndex, List<String> tokens){
    int invalidIndex = tokenIndex;
    if(tokenIndex > 0){
      invalidIndex = List<int>.generate(tokenIndex, (i) => tokens[i].length).reduce((a, b) => a + b);
    }

    if(tokenIndex > -1 && tokens.isNotEmpty){
      String token = tokens[tokenIndex];
      invalidIndex += _analyzeToken(token);
    }

    return invalidIndex;
  }

  int _analyzeToken(String token){
    int startIndex = token.startsWith('`') ? 1 : 0;
    bool match = false;
    int tokenMatch = token.length;
    for(;tokenMatch>=0 && !match;tokenMatch--){
      match = Pattern.validOperand.hasMatch(token.substring(startIndex,tokenMatch));
    }
    return tokenMatch + 1;
  }

}
