
void addFloatStdLib(StaticContext ctx) {
  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("PI"), FLOAT_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new FloatValue((float)Math.PI);
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkVariableCallableIdent("E"), FLOAT_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new FloatValue((float)Math.E);
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkBinaryOpCallableIdent("+", FLOAT_TYPE_NAME, FLOAT_TYPE_NAME), FLOAT_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float a = ((FloatValue)params.get(0)).value;
      float b = ((FloatValue)params.get(1)).value;
      return new FloatValue(a + b);
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkBinaryOpCallableIdent("-", FLOAT_TYPE_NAME, FLOAT_TYPE_NAME), FLOAT_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float a = ((FloatValue)params.get(0)).value;
      float b = ((FloatValue)params.get(1)).value;
      return new FloatValue(a - b);
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkBinaryOpCallableIdent("*", FLOAT_TYPE_NAME, FLOAT_TYPE_NAME), FLOAT_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float a = ((FloatValue)params.get(0)).value;
      float b = ((FloatValue)params.get(1)).value;
      return new FloatValue(a * b);
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkBinaryOpCallableIdent("/", FLOAT_TYPE_NAME, FLOAT_TYPE_NAME), FLOAT_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float a = ((FloatValue)params.get(0)).value;
      float b = ((FloatValue)params.get(1)).value;
      return new FloatValue(a / b);
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkBinaryOpCallableIdent("%", FLOAT_TYPE_NAME, FLOAT_TYPE_NAME), FLOAT_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float a = ((FloatValue)params.get(0)).value;
      float b = ((FloatValue)params.get(1)).value;
      return new FloatValue(a % b);
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkUnaryOpCallableIdent("+", FLOAT_TYPE_NAME), FLOAT_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
      return new FloatValue(+x);
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkUnaryOpCallableIdent("-", FLOAT_TYPE_NAME), FLOAT_TYPE_NAME) {
    @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
      return new FloatValue(-x);
    }
  }
  );

  ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("rand", Arrays.asList(new String[] { })), FLOAT_TYPE_NAME) {
      @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
        return new FloatValue(random(0, 1));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("rand", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue(random(0, x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("rand", Arrays.asList(new String[] { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
float y = ((FloatValue)params.get(1)).value;
return new FloatValue(random(x, y));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("sin", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.sin(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("cos", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.cos(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("tan", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.tan(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("log", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.log(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("exp", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.exp(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("max", Arrays.asList(new String[] { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
float y = ((FloatValue)params.get(1)).value;
return new FloatValue(Math.max(x, y));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("min", Arrays.asList(new String[] { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
float y = ((FloatValue)params.get(1)).value;
return new FloatValue(Math.min(x, y));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("sqrt", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.sqrt(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("abs", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue(Math.abs(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("rand_theta", Arrays.asList(new String[] { })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      return new FloatValue(random(0.0, 2 * PI));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("to_rad", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue(x * PI / 180);
}
});


ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("pow", Arrays.asList(new String[] { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float a = ((FloatValue)params.get(0)).value;
float b = ((FloatValue)params.get(1)).value;
return new FloatValue((float)Math.pow(a, b));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("round", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.round(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("ceil", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.ceil(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("floor", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.floor(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("atan", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.atan(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("asin", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.asin(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("acos", Arrays.asList(new String[] { FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
return new FloatValue((float)Math.acos(x));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("atan2", Arrays.asList(new String[] { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME })), FLOAT_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float x = ((FloatValue)params.get(0)).value;
float y = ((FloatValue)params.get(1)).value;
return new FloatValue((float)Math.atan2(x, y));
}
});


}
