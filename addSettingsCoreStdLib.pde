void addSettingsCoreStdLib(StaticContext ctx) {
  for (String ident : new String[] { "init_pos", "p0" }) {

  ctx.addCmd(new CmdDefinition(new CmdIdent(false, ident, Arrays.asList(new String[] { VEC_TYPE_NAME }))) {
      @Override
      public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
        PVector x = ((VecValue)params.get(0)).value;

  BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

  ball = ball.withP(x);

  dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent(ident), VEC_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new VecValue(ball.p);
  }
}
);

  }

for (String ident : new String[] { "init_vel", "v0" }) {

ctx.addCmd(new CmdDefinition(new CmdIdent(false, ident, Arrays.asList(new String[] { VEC_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      PVector x = ((VecValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withV0(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent(ident), VEC_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new VecValue(ball.v0);
  }
}
);

}

for (String ident : new String[] { "acc", "a" }){

ctx.addCmd(new CmdDefinition(new CmdIdent(false, ident, Arrays.asList(new String[] { VEC_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      PVector x = ((VecValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withAcc(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent(ident), VEC_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new VecValue(ball.acc);
  }
}
);

}

for (String ident : new String[] { "init_color", "c0" }) {

ctx.addCmd(new CmdDefinition(new CmdIdent(false, ident, Arrays.asList(new String[] { COLOR_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      Color x = ((ColorValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withC0(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent(ident), COLOR_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new ColorValue(ball.c0);
  }
}
);

}

for (String ident : new String[] { "delta_color", "dc" }) {

ctx.addCmd(new CmdDefinition(new CmdIdent(false, ident, Arrays.asList(new String[] { COLOR_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      Color x = ((ColorValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withDc(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent(ident), COLOR_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new ColorValue(ball.dc);
  }
}
);

}

for (String ident : new String[] { "init_radius", "r0" }) {

ctx.addCmd(new CmdDefinition(new CmdIdent(false, ident, Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float x = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withR0(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent(ident), FLOAT_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new FloatValue(ball.r0);
  }
}
);

}

for (String ident : new String[] { "delta_radius", "dr" }) {

ctx.addCmd(new CmdDefinition(new CmdIdent(false, ident, Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float x = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withDr(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent(ident), FLOAT_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new FloatValue(ball.dr);
  }
}
);

}

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "lifetime", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float x = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withLife(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("lifetime"), FLOAT_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new FloatValue(ball.life);
  }
}
);
}
