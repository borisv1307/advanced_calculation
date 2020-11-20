class TranslatePattern {
  static final TranslatePattern _singleton = TranslatePattern._internal();
  factory TranslatePattern() {
    return _singleton;
  }
  TranslatePattern._internal();

  static final RegExp spacing = new RegExp(r'\s+');
  static final RegExp openParen = new RegExp(r"\(");
  static final RegExp closeParen = new RegExp(r"\)");
  static final RegExp numberX = new RegExp(r'([0-9]+|[𝜋𝑒])([a-z]+)', unicode: true);
  static final RegExp numberParen = new RegExp(r'([0-9]+|[𝜋𝑒])(\()', unicode: true);
  static final RegExp numberConst = new RegExp(r'([0-9]+|[𝜋𝑒])([𝜋𝑒])', unicode: true);
}
