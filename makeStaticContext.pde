StaticContext makeStaticContext() {
  StaticContext ctx = new StaticContext();

  addFloatStdLib(ctx);
  addColorStdLib(ctx);
  addVecStdLib(ctx);
  addCoreStdLib(ctx);
  addSettingsCoreStdLib(ctx);
  addSettingsUtilStdLib(ctx);
  addBlockCmdStdLib(ctx);

  return ctx;
}

<A> A ListGetOr(List<A> list, int i, A defaultValue) {
  return i < list.size() ? list.get(i) : defaultValue;
}
