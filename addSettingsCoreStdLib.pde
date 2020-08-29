void addSettingsCoreStdLib(StaticContext ctx) {
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
}
