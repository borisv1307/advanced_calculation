// This class represents the possible Regex patterns used for input validation
class Pattern {
  static final validOperand = RegExp(r'^-?[0-9]+(.[0-9]+)?$|^[𝜋𝑒]$', unicode: true);
  static final validAllOperator = RegExp(r'^[,+\-\/*^=)]$');
  static final validNoPlusMinusOperator = RegExp(r'^[)^,*\/=]$');
  static final validBasicOperator = RegExp(r'^[+\-\/*^]$');
  static final validCommaBasicOperator = RegExp(r'^[,+\-\/*^]$');
}