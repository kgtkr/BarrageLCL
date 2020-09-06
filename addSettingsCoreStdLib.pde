void addSettingsCoreStdLib(StaticContext ctx) {
  ctx.addCmd(new CmdDefinition(new CmdIdent(false, "init_pos", Arrays.asList(new String[] { VEC_TYPE_NAME }))) {
      @Override
      public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
        PVector x = ((VecValue)params.get(0)).value;

  BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

  ball = ball.withP(x);

  dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("init_pos"), VEC_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new VecValue(ball.p);
  }
}
);

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "init_vel", Arrays.asList(new String[] { VEC_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      PVector x = ((VecValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withV0(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("init_vel"), VEC_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new VecValue(ball.v0);
  }
}
);

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "acc", Arrays.asList(new String[] { VEC_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      PVector x = ((VecValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withAcc(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("acc"), VEC_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new VecValue(ball.acc);
  }
}
);

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "init_color", Arrays.asList(new String[] { COLOR_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      Color x = ((ColorValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withC0(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("init_color"), COLOR_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new ColorValue(ball.c0);
  }
}
);

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "delta_color", Arrays.asList(new String[] { COLOR_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      Color x = ((ColorValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withDc(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("delta_color"), COLOR_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new ColorValue(ball.dc);
  }
}
);

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "init_radius", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float x = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withR0(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("init_radius"), FLOAT_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new FloatValue(ball.r0);
  }
}
);

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "delta_radius", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float x = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withDr(x);

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("delta_radius"), FLOAT_TYPE_NAME) {
  @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
    BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

    return new FloatValue(ball.dr);
  }
}
);

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
