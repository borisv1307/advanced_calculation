class MantissaTransformer{
  String transform(final String rawInput, final int precision){
    String integral = rawInput;
    String afterE = '';

    int eIndex = rawInput.indexOf('E');
    if(eIndex != -1){
      integral = rawInput.substring(0,eIndex);
      afterE = rawInput.substring(eIndex);
    }
    double input = double.parse(integral);

    String result = input.toString();
    if((precision == -1 && input == input.truncateToDouble()) || precision == 0){
      result = input.toStringAsFixed(0);
    }else if(precision > -1){
      result = input.toStringAsFixed(precision);
    }
    return result + afterE;

  }
}