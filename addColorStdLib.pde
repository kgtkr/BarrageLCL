void addColorStdLib(StaticContext ctx) {

  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("red"), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new ColorValue(new Color(1, 0, 0, 1));
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("green"), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new ColorValue(new Color(0, 1, 0, 1));
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("blue"), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new ColorValue(new Color(0, 0, 1, 1));
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("cyan"), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new ColorValue(new Color(0, 1, 1, 1));
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("magenta"), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new ColorValue(new Color(1, 0, 1, 1));
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("yellow"), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new ColorValue(new Color(1, 1, 0, 1));
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("black"), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new ColorValue(new Color(0, 0, 0, 1));
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("white"), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new ColorValue(new Color(1, 1, 1, 1));
    }
  }
  );

  for (String[] pts : new String[][] {
  { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME, FLOAT_TYPE_NAME }, 
  { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME, FLOAT_TYPE_NAME, FLOAT_TYPE_NAME }
  }) {
  ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("color", Arrays.asList(pts)), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float r = ((FloatValue)params.get(0)).value;
      float g = ((FloatValue)params.get(1)).value;
      float b = ((FloatValue)params.get(2)).value;
      float a = ((FloatValue)listGetOr(params, 3, new FloatValue(1))).value;
      return new ColorValue(new Color(r, g, b, a));
    }
  }
  );
}

for (String[] pts : new String[][] {
  { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME, FLOAT_TYPE_NAME }, 
  { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME, FLOAT_TYPE_NAME, FLOAT_TYPE_NAME }
  }) {
  ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("dcolor", Arrays.asList(pts)), COLOR_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float r = ((FloatValue)params.get(0)).value;
      float g = ((FloatValue)params.get(1)).value;
      float b = ((FloatValue)params.get(2)).value;
      float a = ((FloatValue)listGetOr(params, 3, new FloatValue(0))).value;
      return new ColorValue(new Color(r, g, b, a));
    }
  }
  );
}
}