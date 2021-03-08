class NegativeHelper {
  NegativeHelper();

  String sanitizeToken(String token){
    String sanitizedToken = token;
    //handle special negatives for complex functions
    while(sanitizedToken.startsWith('`') && sanitizedToken.length > 1) {
      sanitizedToken = sanitizedToken.substring(1); // remove the negatives
    }

    return sanitizedToken;
  }
}