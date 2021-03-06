import 'package:advanced_calculation/display_style.dart';

class DisplayStyleTransformer{
  String transform(String input, DisplayStyle style){
    String  output = input;
    if(style == DisplayStyle.SCIENTIFIC){
      output = transformScientific(input);
    }else if(style == DisplayStyle.ENGINEERING){
      output = transformEngineering(input);
    }

    return output;
  }

  String transformScientific(String input){
    int power = determineMaxPower(input);
    return transformPower(input, power);
  }


  String transformEngineering(String input) {
    int power = determineMaxPower(input);
    return transformPower(input, power - (power%3));
  }

  int determineMaxPower(String input){
    String integral = input;

    int decimalPosition = input.indexOf('.');
    if(decimalPosition != -1){
      integral = input.substring(0,decimalPosition);
    }
    int power = integral.length - 1;

    return power;
  }

  String transformPower(String input, int power){
    String decimal = '';
    String integral = input;

    int decimalPosition = input.indexOf('.');
    if(decimalPosition != -1){
      decimal = input.substring(decimalPosition + 1);
      integral = input.substring(0,decimalPosition);
    }

    String updated = integral.substring(0, integral.length - power) + '.' + integral.substring(integral.length - power) + decimal;

    return '${removeTrailingZeros(updated)}E$power';
  }

  String removeTrailingZeros(String input){
    String output = input;
    while(output.endsWith('0') && output.length > 1){
      output = output.substring(0,output.length-1);
    }
    if(output.endsWith('.')){
      output = output.substring(0,output.length-1);
    }

    return output;
  }
}