// posは全てソース文字列上の位置

enum TokenKind {
  Op, 
    OpenParent, 
    CloseParent, 
    OpenBrace, 
    CloseBrace, 
    Ident, 
    Atmark, 
    Comma, 
    Semicolon, 
    FloatLiteral, 

    Spaces, 
    LineComment, 
    NewLine, 
    InvalidChar,
}

class Token {
  final TokenKind kind;
  final int begin;
  final int end;
  final String value;

  Token(TokenKind kind, int begin, int end, String value) {
    this.kind = kind;
    this.begin = begin;
    this.end = end;
    this.value = value;
  }
}

boolean equalsTokens(List<Token> a, List<Token> b) {
  if (a.size() != b.size()) {
    return false;
  }

  for (int i = 0; i < a.size(); i++) {
    Token x= a.get(i);
    Token y = b.get(i);

    if (x.kind != y.kind) {
      return false;
    }

    if (!x.value.equals(y.value)) {
      return false;
    }
  }

  return true;
}
