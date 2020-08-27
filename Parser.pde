import java.lang.Float;

// posは全てトークン列の位置

class ParseException extends RuntimeException {
  final String expect;
  final String actual;
  final int pos;

  ParseException(String expect, String actual, int pos) {
    super("Parse error. expect: " + expect + ", actual: " + "'" + actual + "'");

    this.expect = expect;
    this.actual = actual;
    this.pos = pos;
  }

  ParseException withExpect(String expect) {
    return new ParseException(expect, this.actual, this.pos);
  }
}

class Parser {
  final List<Token> src;
  int pos;

  Parser(List<Token> src) {
    this.src = src;
    this.pos = 0;
  }

  // eofならnull
  Token peak() {
    if (this.pos < this.src.size()) {
      return this.src.get(this.pos);
    } else {
      return null;
    }
  }

  Token popKind(String expect, TokenKind kind) {
    return this.popKinds(expect, new TokenKind[]{ kind });
  }

  Token popKinds(String expect, TokenKind[] kinds) {
    Token token = this.peak();
    if (token == null) {
      throw new ParseException(expect, "<EOF>", this.pos);
    }

    for (TokenKind kind : kinds) {
      if (kind == token.kind) {
        this.pos++;
        return token;
      }
    }

    throw new ParseException(expect, token.value, this.pos);
  }

  Program parseProgram() {
    int startPos = this.pos;
    List<Cmd> cmds = new ArrayList();

    while (true) {
      if (this.pos == this.src.size()) {
        return new Program(cmds, startPos, this.pos);
      }

      int parseCmdStartPos = this.pos;
      try {
        cmds.add(this.parseCmd());
      } 
      catch (ParseException e) {
        if (this.pos == parseCmdStartPos) {
          throw e.withExpect("cmd or <EOF>");
        } else {
          throw e;
        }
      }
    }
  }

  Cmd parseCmd() {
    int startPos = this.pos;
    Token cmdName = this.popKind("ident", TokenKind.Ident);
    List<Expr> params = new ArrayList();
    while (true) {
      Token nextToken = this.peak();
      if (nextToken != null && nextToken.kind == TokenKind.Semicolon) {
        this.pos++;
        return new ProcCmd(cmdName.value, params, startPos, this.pos);
      }

      if (nextToken != null && (nextToken.kind == TokenKind.Atmark || nextToken.kind == TokenKind.OpenBrace)) {
        boolean createCtx = true;
        if (nextToken.kind == TokenKind.Atmark) {
          this.pos++;
          createCtx = false;
        }
        this.popKind("'{'", TokenKind.OpenBrace);
        List<Cmd> block = new ArrayList();
        while (true) {
          Token closeOrElse = this.peak();
          if (closeOrElse !=null && closeOrElse.kind == TokenKind.CloseBrace ) {
            this.pos++;
            return new BlockCmd(cmdName.value, params, createCtx, block, startPos, this.pos);
          }

          int parseCmdStartPos = this.pos;
          try {
            block.add(this.parseCmd());
          } 
          catch (ParseException e) {
            if (this.pos == parseCmdStartPos) {
              throw e.withExpect("cmd or '}'");
            } else {
              throw e;
            }
          }
        }
      }

      int parseExprStartPos = this.pos;
      try {
        params.add(this.parseExprWithoutBinaryOp());
      } 
      catch (ParseException e) {
        if (this.pos == parseExprStartPos) {
          throw e.withExpect("expr or '{' or '@' or ';'");
        } else {
          throw e;
        }
      }
    }
  }

  Expr parseExpr() {
    Expr expr = this.parseExprWithoutAddSub();
    while (true) {
      Token op = this.peak();
      if (op != null && op.kind == TokenKind.Op && (op.value.startsWith("+") || op.value.startsWith("-"))) {
        this.pos++;
      } else {
        return expr;
      }

      Expr rexpr = this.parseExprWithoutAddSub();
      expr = new BinaryOpExpr(op.value, expr, rexpr, expr.begin, rexpr.end);
    }
  }

  // +と-から始まる二項演算子を除いた式
  Expr parseExprWithoutAddSub() {
    Expr expr = this.parseExprWithoutBinaryOp();
    while (true) {
      Token op = this.peak();
      if (op != null && op.kind == TokenKind.Op && (op.value.startsWith("*") || op.value.startsWith("/") || op.value.startsWith("%"))) {
        this.pos++;
      } else {
        return expr;
      }

      Expr rexpr = this.parseExprWithoutBinaryOp();
      expr = new BinaryOpExpr(op.value, expr, rexpr, expr.begin, rexpr.end);
    }
  }

  // 2項演算子を除いた式
  Expr parseExprWithoutBinaryOp() {
    int startPos = this.pos;
    Token token = this.popKinds("expr", new TokenKind[]{ TokenKind.Op, TokenKind.OpenParent, TokenKind.FloatLiteral, TokenKind.Ident });

    switch (token.kind) {
    case Op: 
      {
        Expr expr = this.parseExprWithoutBinaryOp();
        return new UnaryOpExpr(token.value, expr, startPos, expr.end);
      }
    case OpenParent: 
      {
        Expr expr = this.parseExpr();
        this.popKind(")", TokenKind.CloseParent);

        return new ParentExpr(expr, startPos, this.pos);
      }
    case FloatLiteral: 
      {
        return new FloatLiteralExpr(Float.parseFloat(token.value), startPos, this.pos);
      }
    case Ident: 
      {
        Token openOrElse = this.peak();
        if (openOrElse == null || openOrElse.kind != TokenKind.OpenParent) {
          return new VariableExpr(token.value, startPos, this.pos);
        }
        this.pos++;
        List<Expr> params = new ArrayList();
      ret: 
        while (true) {
          Token closeOrElse = this.peak();
          if (closeOrElse == null) {
            throw new ParseException("expr or ')'", "<EOF>", this.pos);
          }
          if (closeOrElse.kind == TokenKind.CloseParent) {
            this.pos++;
            break ret;
          }

          int parseExprStartPos = this.pos;
          try {
            params.add(this.parseExpr());
          }  
          catch (ParseException e) {
            if (this.pos == parseExprStartPos) {
              throw e.withExpect("expr or ')'");
            } else {
              throw e;
            }
          }
          Token closeOrComma = this.popKinds("')' or ','", new TokenKind[]{ TokenKind.Comma, TokenKind.CloseParent });
          if (closeOrComma.kind == TokenKind.CloseParent) {
            break ret;
          }
        }

        return new CallFuncExpr(token.value, params, startPos, this.pos);
      }
    default: 
      {
        throw new RuntimeException("unreachable");
      }
    }
  }
}
