// This class represents the possible Regex patterns used for input validation
class Pattern {
  static final validOperand = RegExp(r'^((\d*\.?)(\.\d+)?)?(𝜋|𝑒|𝑥)?$', unicode: true);
  static final validPower = RegExp(r'^²|⁻¹$');
  static final validAllOperator = RegExp(r'^[,+\-\/*^)]$');
  static final validNoPlusMinusOperator = RegExp(r'^[)^,*\/]$');
  static final validBasicOperator = RegExp(r'^[+\-\/*^]$');
  static final validCommaBasicOperator = RegExp(r'^[,+\-\/*^]$');
  static final validOperator = RegExp(r'^[+\-\/*]$');
  static final addSubtractOperator = RegExp(r'^[+\-]$');
  static final multiplyDivideOperator = RegExp(r'^[*\/]$');
  static final validMatrixOperand = RegExp(r'^((\d*\.?)(\.\d+)?)?(𝜋|𝑒)?$', unicode: true);
}