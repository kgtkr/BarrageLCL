// posは全てソース文字列上の位置

import java.util.regex.Pattern;
import java.util.regex.Matcher;

final TokenPattern[] tokenPatterns = {
  new TokenPattern(Pattern.compile("^[\\+\\-\\*\\/\\%]+"), TokenKind.Op), 
  new TokenPattern(Pattern.compile("^\\("), TokenKind.OpenParent), 
  new TokenPattern(Pattern.compile("^\\)"), TokenKind.CloseParent), 
  new TokenPattern(Pattern.compile("^\\{"), TokenKind.OpenBrace), 
  new TokenPattern(Pattern.compile("^\\}"), TokenKind.CloseBrace), 
  new TokenPattern(Pattern.compile("^[a-zA-Z_][a-zA-Z0-9_]*"), TokenKind.Ident), 
  new TokenPattern(Pattern.compile("^\\@"), TokenKind.Atmark), 
  new TokenPattern(Pattern.compile("^\\,"), TokenKind.Comma), 
  new TokenPattern(Pattern.compile("^\\;"), TokenKind.Semicolon), 
  new TokenPattern(Pattern.compile("^[0-9]+(\\.[0-9]+)?"), TokenKind.FloatLiteral), 
  new TokenPattern(Pattern.compile("^ +"), TokenKind.Spaces), 
  new TokenPattern(Pattern.compile("^\\n"), TokenKind.NewLine), 
  new TokenPattern(Pattern.compile("^\\#[^\\n]*"), TokenKind.LineComment), 
  new TokenPattern(Pattern.compile("^."), TokenKind.InvalidChar), 
};

class LexerException extends RuntimeException {
  final int pos;

  LexerException(String c, int pos) {
    super("Lexer error. Unknown char: '" + c + "'");

    this.pos = pos;
  }
}

class TokenPattern {
  final Pattern pattern;
  final TokenKind kind;

  TokenPattern(Pattern pattern, TokenKind kind) {
    this.pattern = pattern;
    this.kind = kind;
  }
}

class Lexer {
  final String src;
  int pos;

  Lexer (String src) {
    this.src = src;
    this.pos = 0;
  }

  List<Token> parseTokens() {
    List<Token> tokens = new ArrayList();
    while (this.pos < this.src.length()) {
      tokens.add(this.parseToken());
    }

    return tokens;
  }

  Token parseToken() {
    for (TokenPattern tokenPattern : tokenPatterns) {
      int begin = this.pos;
      String value = this.matchPattern(tokenPattern.pattern);
      if (value != null) {
        int end = this.pos;
        return new Token(tokenPattern.kind, begin, end, value);
      }
    }

    throw new RuntimeException("unreachable");
  }

  // マッチしたらposを進めて文字列を返す。マッチしなければnull
  String matchPattern(Pattern pattern) {
    Matcher matcher = pattern.matcher(this.src.substring(this.pos));
    while (matcher.find()) {
      String matched = matcher.group();
      this.pos += matched.length();
      return matched;
    }

    return null;
  }
}

List<Token> validTokens(List<Token> tokens) {
  List<Token> result = new ArrayList();

  for (Token token : tokens) {
    switch (token.kind) {
    case Spaces:
    case LineComment:
    case NewLine:
      {
        break;
      }

    case InvalidChar: 
      {
        throw new LexerException(token.value, token.begin);
      }
    default:
      {
        result.add(token);
        break;
      }
    }
  }
  return result;
}
