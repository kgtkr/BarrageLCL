void addCoreStdLib(StaticContext ctx) {
  for (int i = 0; i < 2; i++) {
    ctx.addCallable(new CallableDefinition(
      i == 0
      ? mkFunctionCallableIdent("i", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))
      : mkVariableCallableIdent("i"), 
      FLOAT_TYPE_NAME
      ) {
        @Override
        public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
          float nf = params == null ? 0 : ((FloatValue)params.get(0)).value;
    int n = (int)nf;
    return new FloatValue(dynCtx.countStack.get(dynCtx.countStack.size() - 1 - n));
  }

  @Override
    public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, int begin, int end) {
    float nf;
    if (params == null) {
      nf = 0;
    } else {
      Expr paramExpr = params.get(0);
      if (!(paramExpr instanceof FloatLiteralExpr)) {
        throw new StaticCheckException("n must be a float literal.", begin, end);
      }

      nf = ((FloatLiteralExpr)paramExpr).value;
    }

    if (nf != (int)nf || nf < 0) {
      throw new StaticCheckException("n must be a non-negative integer.", begin, end);
    }

    int n = (int)nf;
    if (n >= blockDepth) {
      throw new StaticCheckException("n must be less than nest depth.", begin, end);
    }
  }
}
);
}

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "shot", Arrays.asList(new String[] {}))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

dynCtx.balls.add(ball);
}

@Override
  public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  if (blockDepth == 0) {
    throw new StaticCheckException("shot cannot be used on the outermost side.", begin, end);
  }
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "se", Arrays.asList(new String[] {}))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      dynCtx.playSound = true;
}

@Override
  public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  if (blockDepth == 0) {
    throw new StaticCheckException("shot cannot be used on the outermost side.", begin, end);
  }
}
});
}