
class DSLAnalizer extends CodeAnalizer {
  StaticContext ctx;
  List<Token> tokens = new ArrayList();
  List<SuggestionItem> suggestionItems = new ArrayList();
  Runner runner;

  DSLAnalizer(Runner runner, StaticContext ctx) {
    this.runner = runner;
    this.ctx = ctx;

    this.runner.applyProgram(new Program(new ArrayList(), 0, 0));

    for (CmdIdent ident : this.ctx.cmds.keySet()) {
      this.suggestionItems.add(new SuggestionItem(ident.name, ident.toString()));
    }

    for (CallableDefinition callable : this.ctx.callables.values()) {
      if (callable.ident.kind == CallableIdentKind.Variable || callable.ident.kind == CallableIdentKind.Function) {
        this.suggestionItems.add(new SuggestionItem(callable.ident.name, callable.ident.toString() + " : " + callable.type));
      }
    }

    Collections.sort(this.suggestionItems);
  }

  @Override
    Suggestion suggest(String code, int pos) {
    List<Token> tokens = new Lexer(code).parseTokens();

    String token = null;
    for (Token t : tokens) {
      if (t.kind == TokenKind.Ident && t.end == pos) {
        token = t.value;
        break;
      }
    }

    if (token == null) {
      return null;
    }

    List<SuggestionItem> suggestionItems = new ArrayList();

    for (SuggestionItem item : this.suggestionItems) {
      if (item.isMatch(token)) {
        suggestionItems.add(item);
      }
    }

    if (suggestionItems.size() == 0) {
      return null;
    }

    return new Suggestion(suggestionItems, token.length());
  }

  @Override
    String applySuggest(String code, int pos, String item) {
    List<Token> tokens = new Lexer(code).parseTokens();

    String token = null;
    for (Token t : tokens) {
      if (t.kind == TokenKind.Ident && t.end == pos) {
        token = t.value;
        break;
      }
    }

    if (token == null) {
      return null;
    }

    if (item.length() < token.length()) {
      return null;
    }

    return item.substring(token.length());
  }

  @Override
  CodeAnalizerResult analize(String code) {
    CodeAnalizerResult result = new CodeAnalizerResult();
    List<Token> tokens = new Lexer(code).parseTokens();

    for (Token token : tokens) {
      Color c = null;

      switch (token.kind) {
      case LineComment: 
        {
          c = new Color(0, 0.6, 0, 1);
          break;
        }
      case FloatLiteral: 
        {
          c = new Color(1, 1, 0.8, 1);
          break;
        }
      case Ident: 
        {
          c = new Color(0.5, 0.9, 1, 1);
          break;
        }
      }

      if (c != null) {
        for (int i = token.begin; i < token.end; i++) {
          result.highlights.put(i, c);
        }
      }
    }

    try {
      tokens = validTokens(tokens);
    } 
    catch (LexerException e) {
      for (Token token : tokens) {
        boolean isError = false;

        switch (token.kind) {
        case InvalidChar: 
          {
            isError = true;
            break;
          }
        }

        if (isError) {
          for (int i = token.begin; i < token.end; i++) {
            result.errors.add(i);
          }
        }
      }
      result.errorMsg = "Unknown char.";
      return result;
    }

    try {
      Program program = new Parser(tokens).parseProgram();
      program.staticCheck(this.ctx);

      if (!equalsTokens(this.tokens, tokens)) {
        this.tokens = tokens;
        this.runner.applyProgram(program);
      }
    } 
    catch(ParseException e) {
      int begin;
      int end;

      if (e.pos < tokens.size()) {
        begin = tokens.get(e.pos).begin;
        end =  tokens.get(e.pos).end;
      } else {
        begin = code.length();
        end = code.length() + 1;
      }

      result.errorMsg = e.getMessage();
      for (int i = begin; i < end; i++) {
        result.errors.add(i);
      }
      return result;
    } 
    catch(StaticCheckException e) {
      int begin = e.begin < tokens.size() ? tokens.get(e.begin).begin : code.length();
      int end = e.end <= tokens.size() ? tokens.get(e.end - 1).end : code.length();

      result.errorMsg = e.getMessage();
      for (int i = begin; i < end; i++) {
        result.errors.add(i);
      }
      return result;
    }

    return result;
  }
}
