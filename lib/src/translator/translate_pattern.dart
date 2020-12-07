class TranslatePattern {
  static final TranslatePattern _singleton = TranslatePattern._internal();
  factory TranslatePattern() {
    return _singleton;
  }
  TranslatePattern._internal();

  static final RegExp spacing = new RegExp(r'\s+');
  static final RegExp openParen = new RegExp(r"\(");
  static final RegExp closeParen = new RegExp(r"\)");
  static final RegExp numberX = new RegExp(r'([0-9]+)([𝜋𝑒𝑥]|[a-z]+)', unicode: true); // 3x, 3sin
  static final RegExp xNumber = new RegExp(r'([𝜋𝑒𝑥])([0-9]+)', unicode: true);        // x3, 𝜋3
  static final RegExp xAdj = new RegExp(r'([𝜋𝑒𝑥])([𝜋𝑒𝑥]|[a-z]+)', unicode: true);     // xsin, 𝜋x
  static final RegExp numberParen = new RegExp(r'([0-9]+|[𝜋𝑒𝑥])(\()', unicode: true); // 3(, x(
}