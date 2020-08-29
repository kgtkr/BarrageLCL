StaticContext makeStaticContext() {
  StaticContext ctx = new StaticContext();

  addConstStaticContext(ctx);
  addFunctionStaticContext(ctx);
  addIndexVariableStaticContext(ctx);
  addBlockCmdStaticContext(ctx);
  addProcCmdStaticContext(ctx);
  addFloatStdLib(ctx);
  addColorStdLib(ctx);
  addVecStdLib(ctx);

  return ctx;
}

<A> A ListGetOr(List<A> list, int i, A defaultValue) {
  return i < list.size() ? list.get(i) : defaultValue;
}

void addIndexVariableStaticContext(StaticContext ctx) {
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
}

void addBlockCmdStaticContext(StaticContext ctx) {
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

void addProcCmdStaticContext(StaticContext ctx) {
  ctx.addCmd(new CmdDefinition(new CmdIdent(false, "v0", Arrays.asList(new String[] { VEC_TYPE_NAME }))) {
      @Override
      public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
        PVector x = ((VecValue)params.get(0)).value;

  BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

  ball = ball.withV0(x);

  dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "acc", Arrays.asList(new String[] { VEC_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      PVector x = ((VecValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withAcc(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "c0", Arrays.asList(new String[] { COLOR_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      Color x = ((ColorValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withC0(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "dc", Arrays.asList(new String[] { COLOR_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      Color x = ((ColorValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withDc(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "r0", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float x = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withR0(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "dr", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float x = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withDr(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "life", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float x = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withLife(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

for (String[] pts : new String[][] {
  { FLOAT_TYPE_NAME }, 
  { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME }
  }) {
  ctx.addCmd(new CmdDefinition(new CmdIdent(false, "fadein", Arrays.asList(pts))) {
    @Override
      public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float t = ((FloatValue)params.get(0)).value;
      float init = ((FloatValue)ListGetOr(params, 1, new FloatValue(0))).value;

      BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

      ball = ball.withC0(new Color(ball.c0.r, ball.c0.g, ball.c0.b, init));
      ball = ball.withDc(new Color(ball.dc.r, ball.dc.g, ball.dc.b, 1.0 / t));

      dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
    }
  }
  );
}

for (String[] pts : new String[][] {
  { FLOAT_TYPE_NAME }, 
  { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME }
  }) {
  ctx.addCmd(new CmdDefinition(new CmdIdent(false, "fadeout", Arrays.asList(pts))) {
    @Override
      public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float t = ((FloatValue)params.get(0)).value;
      float init = ((FloatValue)ListGetOr(params, 1, new FloatValue(1))).value;

      BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

      ball = ball.withC0(new Color(ball.c0.r, ball.c0.g, ball.c0.b, init));
      ball = ball.withDc(new Color(ball.dc.r, ball.dc.g, ball.dc.b, -1.0 / t));

      dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
    }
  }
  );
}

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "c2c", Arrays.asList(new String[] { COLOR_TYPE_NAME, COLOR_TYPE_NAME, FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      Color c0 = ((ColorValue)params.get(0)).value;
Color ct = ((ColorValue)params.get(1)).value;
float t = ((FloatValue)params.get(2)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withC0(c0);
ball = ball.withDc(new Color(
  (ct.r - c0.r) / t, 
  (ct.g - c0.g) / t, 
  (ct.b - c0.b) / t, 
  (ct.a - c0.a) / t
  ));

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "speedup", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float k = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withAcc(new PVector(ball.v0.x * k, ball.v0.y * k, ball.v0.z * k));

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

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
