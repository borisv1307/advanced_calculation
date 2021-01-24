class MantissaTransformer{
  String transform(final double input, final int precision){
    String result = input.toString();
    if((precision == -1 && input == input.truncateToDouble()) || precision == 0){
      result = input.toStringAsFixed(0);
    }else if(precision > -1){
      result = input.toStringAsFixed(precision);
    }
    return result;

  }
}