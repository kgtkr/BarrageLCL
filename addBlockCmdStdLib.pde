void addBlockCmd(StaticContext ctx) {
  ctx.addCmd(new CmdDefinition(new CmdIdent(true, "times", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
      @Override
      public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
        int n = (int)((FloatValue)params.get(0)).value;
  for (int i = 0; i < n; i++) {
    runBlock(ctx, dynCtx, block, createCtx, i);
  }
}

@Override
  public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  Expr paramExpr = params.get(0);
  if (!(paramExpr instanceof FloatLiteralExpr)) {
    throw new StaticCheckException("n must be a float literal.", begin, end);
  }

  float nf = ((FloatLiteralExpr)paramExpr).value;

  if (nf != (int)nf || nf <= 0) {
    throw new StaticCheckException("n must be a positive integer.", begin, end);
  }
}

@Override
  public int loopCount(List<Expr> params) {
  return (int)((FloatLiteralExpr)params.get(0)).value;
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(true, "cycle", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      int n = max(0, (int)((FloatValue)params.get(0)).value);
int i = dynCtx.countStack.get(dynCtx.countStack.size() - 1);

runBlock(ctx, dynCtx, block, createCtx, i % n);
}

@Override
  public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  if (blockDepth == 0) {
    throw new StaticCheckException("cycle cannot be used on the outermost side.", begin, end);
  }
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(true, "skip", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      int n = max(0, (int)((FloatValue)params.get(0)).value);
int i = dynCtx.countStack.get(dynCtx.countStack.size() - 1);

if (i >= n) {
  runBlock(ctx, dynCtx, block, createCtx, i - n);
}
}

@Override
  public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  if (blockDepth == 0) {
    throw new StaticCheckException("skip cannot be used on the outermost side.", begin, end);
  }
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(true, "thin", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      int n = max(0, (int)((FloatValue)params.get(0)).value);
int i = dynCtx.countStack.get(dynCtx.countStack.size() - 1);

if (i % n == 0) {
  runBlock(ctx, dynCtx, block, createCtx, i / n);
}
}

@Override
  public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  if (blockDepth == 0) {
    throw new StaticCheckException("thin cannot be used on the outermost side.", begin, end);
  }
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(true, "take", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      int n = max(0, (int)((FloatValue)params.get(0)).value);
int i = dynCtx.countStack.get(dynCtx.countStack.size() - 1);

if (i < n) {
  runBlock(ctx, dynCtx, block, createCtx, i);
}
}

@Override
  public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  if (blockDepth == 0) {
    throw new StaticCheckException("take cannot be used on the outermost side.", begin, end);
  }
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(true, "sec_per", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float t = ((FloatValue)params.get(0)).value;
int per = Math.max(1, (int)(t * 60));

if (dynCtx.frameCount % per == 0) {
  runBlock(ctx, dynCtx, block, createCtx, dynCtx.frameCount / per);
}
}

@Override
  public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  if (blockDepth != 0) {
    throw new StaticCheckException("sec_per can only be used on the outermost side.", begin, end);
  }
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(true, "per_sec", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float c = ((FloatValue)params.get(0)).value;
int per = Math.max(1, (int)(60 / c));

if (dynCtx.frameCount % per == 0) {
  runBlock(ctx, dynCtx, block, createCtx, dynCtx.frameCount / per);
}
}

@Override
  public void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  if (blockDepth != 0) {
    throw new StaticCheckException("per_sec can only be used on the outermost side.", begin, end);
  }
}
});
}