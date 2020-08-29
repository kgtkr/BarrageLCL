void addVecStdLib(StaticContext ctx) {
  ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("vec", Arrays.asList(new String[] { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME, FLOAT_TYPE_NAME })), VEC_TYPE_NAME) {
      @Override
      public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
        float x = ((FloatValue)params.get(0)).value;
  float y = ((FloatValue)params.get(1)).value;
  float z = ((FloatValue)params.get(2)).value;
  return new VecValue(new PVector(x, y, z));
}
});

ctx.addCallable(new CallableDefinition(mkFunctionCallableIdent("vec_rl", Arrays.asList(new String[] { FLOAT_TYPE_NAME, FLOAT_TYPE_NAME, FLOAT_TYPE_NAME })), VEC_TYPE_NAME) {
    @Override
    public RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params) {
      float r1 = ((FloatValue)params.get(0)).value;
float r2 = ((FloatValue)params.get(1)).value;
float l = ((FloatValue)params.get(2)).value;
return new VecValue(new PVector(
  (float)(l * Math.sin(r1) * Math.cos(r2)), 
  (float)(l * Math.sin(r1) * Math.sin(r2)), 
  (float)(l * Math.cos(r1))
  ));
}
});
}