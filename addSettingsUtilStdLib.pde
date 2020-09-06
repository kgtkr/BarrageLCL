void addSettingsUtilStdLib(StaticContext ctx) {
  for (String[] pts : new String[][] {
    { FLOAT_TYPE_NAME }, 
    { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME }
    }) {
    ctx.addCmd(new CmdDefinition(new CmdIdent(false, "fadein", Arrays.asList(pts))) {
      @Override
        public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
        float t = ((FloatValue)params.get(0)).value;
        float init = ((FloatValue)listGetOr(params, 1, new FloatValue(0))).value;

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
        float init = ((FloatValue)listGetOr(params, 1, new FloatValue(1))).value;

        BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

        ball = ball.withC0(new Color(ball.c0.r, ball.c0.g, ball.c0.b, init));
        ball = ball.withDc(new Color(ball.dc.r, ball.dc.g, ball.dc.b, -1.0 / t));

        dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
      }
    }
    );
  }

  for (String ident : new String[] { "color_to_color", "c2c" }) {

  ctx.addCmd(new CmdDefinition(new CmdIdent(false, ident, Arrays.asList(new String[] { COLOR_TYPE_NAME, COLOR_TYPE_NAME, FLOAT_TYPE_NAME }))) {
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

  }

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "vel_up", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float k = ((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withAcc(new PVector(ball.v0.x * k, ball.v0.y * k, ball.v0.z * k));

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});

ctx.addCmd(new CmdDefinition(new CmdIdent(false, "vel_down", Arrays.asList(new String[] { FLOAT_TYPE_NAME }))) {
    @Override
    public void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx) {
      float k = -((FloatValue)params.get(0)).value;

BallConfig ball = dynCtx.ballStack.get(dynCtx.ballStack.size() - 1);

ball = ball.withAcc(new PVector(ball.v0.x * k, ball.v0.y * k, ball.v0.z * k));

dynCtx.ballStack.set(dynCtx.ballStack.size() - 1, ball);
}
});


}
