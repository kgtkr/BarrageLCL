// posは全てトークン列の位置

import java.util.Arrays;

abstract class ASTItem {
  final int begin;
  final int end;

  ASTItem (int begin, int end) {
    this.begin = begin;
    this.end = end;
  }
}

class Program extends ASTItem {
  final List<Cmd> cmds;

  Program (List<Cmd> cmds, int begin, int end) {
    super(begin, end);

    this.cmds = cmds;
  }

  void staticCheck(StaticContext ctx) {
    for (Cmd cmd : this.cmds) {
      cmd.staticCheck(ctx, 0);
    }
  }

  DynamicContext eval(StaticContext ctx, int frameCount) {
    DynamicContext dynCtx = new DynamicContext(frameCount);
    for (Cmd cmd : this.cmds) {
      cmd.eval(ctx, dynCtx);
    }
    return dynCtx;
  }
}

abstract class Cmd extends ASTItem {
  // 初期は0
  int loopCount;

  Cmd (int begin, int end) {
    super(begin, end);
  }

  // チェックに成功したらloopCountをセット
  abstract void staticCheck(StaticContext ctx, int blockDepth);

  abstract void eval(StaticContext ctx, DynamicContext dynCtx);

  void checkLoopCount() {
    final int MAX_LOOP_COUNT = 1000;
    if (this.loopCount > MAX_LOOP_COUNT) {
      throw new StaticCheckException("Number of loops must be " + MAX_LOOP_COUNT + " or less. Count: " + this.loopCount, this.begin, this.end);
    }
  }
}

class ProcCmd extends Cmd {
  final String name;
  final List<Expr> params; 

  ProcCmd (String name, List<Expr> params, int begin, int end) {
    super(begin, end);

    this.name = name;
    this.params = params;
  }

  @Override
    void staticCheck(StaticContext ctx, int blockDepth) {
    List<String> paramTypes = new ArrayList();
    for (Expr param : this.params) {
      param.staticCheck(ctx, blockDepth);
      paramTypes.add(param.type);
    }

    CmdIdent cmdIdent = new CmdIdent(false, this.name, paramTypes);
    if (!ctx.cmds.containsKey(cmdIdent)) {
      throw new StaticCheckException("Not found cmd: " + cmdIdent.toString(), this.begin, this.end);
    }

    CmdDefinition cmd = ctx.cmds.get(cmdIdent);
    cmd.additionStaticCheck(ctx, blockDepth, this.params, null, this.begin, this.end);
    this.loopCount = cmd.loopCount(this.params);
    this.checkLoopCount();
  }

  @Override
    void eval(StaticContext ctx, DynamicContext dynCtx) {
    List<RuntimeValue> paramValues = new ArrayList();
    List<String> paramTypes = new ArrayList();
    for (Expr param : this.params) {
      paramValues.add(param.eval(ctx, dynCtx));
      paramTypes.add(param.type);
    }

    CmdIdent ident = new CmdIdent(false, this.name, paramTypes);
    CmdDefinition cmd = ctx.cmds.get(ident);

    try {
      cmd.eval(ctx, dynCtx, paramValues, null, false);
    } 
    catch (DynamicException e) {
      dynCtx.errors.add(new DynamicError(e.getMessage(), this.begin, this.end));
    }
  }
}

class BlockCmd extends Cmd {
  final String name;
  final List<Expr> params;
  final boolean createCtx;
  final List<Cmd> block;

  BlockCmd (String name, List<Expr> params, boolean createCtx, List<Cmd> block, int begin, int end) {
    super(begin, end);

    this.name = name;
    this.params = params;
    this.createCtx = createCtx;
    this.block = block;
  }

  @Override
    void staticCheck(StaticContext ctx, int blockDepth) {
    List<String> paramTypes = new ArrayList();
    for (Expr param : this.params) {
      param.staticCheck(ctx, blockDepth);
      paramTypes.add(param.type);
    }

    int loopMax = 1;
    for (Cmd blockCmd : this.block ) {
      blockCmd.staticCheck(ctx, blockDepth + 1);
      loopMax = max(loopMax, blockCmd.loopCount);
    }

    CmdIdent cmdIdent = new CmdIdent(true, this.name, paramTypes);
    if (!ctx.cmds.containsKey(cmdIdent)) {
      throw new StaticCheckException("Not found cmd: " + cmdIdent.toString(), this.begin, this.end);
    }

    CmdDefinition cmd = ctx.cmds.get(cmdIdent);
    cmd.additionStaticCheck(ctx, blockDepth, this.params, this.block, this.begin, this.end);
    this.loopCount = cmd.loopCount(this.params) * loopMax;
    this.checkLoopCount();
  }

  @Override
    void eval(StaticContext ctx, DynamicContext dynCtx) {
    List<RuntimeValue> paramValues = new ArrayList();
    List<String> paramTypes = new ArrayList();
    for (Expr param : this.params) {
      paramValues.add(param.eval(ctx, dynCtx));
      paramTypes.add(param.type);
    }

    CmdIdent ident = new CmdIdent(true, this.name, paramTypes);
    CmdDefinition cmd = ctx.cmds.get(ident);

    cmd.eval(ctx, dynCtx, paramValues, this.block, this.createCtx);
  }
}

void runBlock(StaticContext ctx, DynamicContext dynCtx, List<Cmd> block, boolean createCtx, int i) {
    if (createCtx) {
      dynCtx.ballStack.add(dynCtx.ballStack.get(dynCtx.ballStack.size() - 1));
    }
    dynCtx.countStack.add(i);
    for (Cmd cmd : block) {
      cmd.eval(ctx, dynCtx);
    }
    if (createCtx) {   
      dynCtx.ballStack.remove(dynCtx.ballStack.size() - 1);
    }
    dynCtx.countStack.remove(dynCtx.countStack.size() - 1);
}

abstract class Expr extends ASTItem {
  // 初期null
  String type;

  Expr (int begin, int end) {
    super(begin, end);
  }

  abstract RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx);

  // チェックに成功したらtypeをセット
  abstract void staticCheck(StaticContext ctx, int blockDepth);
}

class ParentExpr extends Expr {
  final Expr expr;
  ParentExpr (Expr expr, int begin, int end) {
    super(begin, end);
    this.expr = expr;
  }

  @Override
    void staticCheck(StaticContext ctx, int blockDepth) {
    this.expr.staticCheck(ctx, blockDepth);
    this.type = this.expr.type;
  }

  @Override
    RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx) {
    return this.expr.eval(ctx, dynCtx);
  }
}


class FloatLiteralExpr extends Expr {
  final float value;
  FloatLiteralExpr (float value, int begin, int end) {
    super(begin, end);
    this.value = value;
  }

  @Override
    void staticCheck(StaticContext ctx, int blockDepth) {
    this.type = FLOAT_TYPE_NAME;
  }

  @Override
    RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx) {
    return new FloatValue(this.value);
  }
}

class VariableExpr extends Expr {
  final String name;
  VariableExpr (String name, int begin, int end) {
    super(begin, end);
    this.name = name;
  }

  @Override
    void staticCheck(StaticContext ctx, int blockDepth) {
    CallableIdent ident = mkVariableCallableIdent(this.name);
    if (!ctx.callables.containsKey(ident)) {
      throw new StaticCheckException("Not found variable: " + ident.toString(), this.begin, this.end);
    }

    CallableDefinition callable = ctx.callables.get(ident);
    // StaticContext ctx, int blockDepth, List<Expr> params, int begin, int end
    callable.additionStaticCheck(ctx, blockDepth, null, this.begin, this.end);
    this.type = callable.type;
  }

  @Override
    RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx) {
    CallableIdent ident = mkVariableCallableIdent(this.name);
    CallableDefinition callable = ctx.callables.get(ident);
    return callable.eval(ctx, dynCtx, null);
  }
}

class UnaryOpExpr extends Expr {
  final String op;
  final Expr expr;
  UnaryOpExpr (String op, Expr expr, int begin, int end) {
    super(begin, end);
    this.op = op;
    this.expr = expr;
  }

  @Override
    void staticCheck(StaticContext ctx, int blockDepth) {
    this.expr.staticCheck(ctx, blockDepth);

    CallableIdent ident = mkUnaryOpCallableIdent(this.op, this.expr.type);
    if (!ctx.callables.containsKey(ident)) {
      throw new StaticCheckException("Not found unaryOp: " + ident.toString(), this.begin, this.end);
    }

    CallableDefinition callable = ctx.callables.get(ident);
    callable.additionStaticCheck(ctx, blockDepth, Arrays.asList(new Expr[] { this.expr }), this.begin, this.end);
    this.type = callable.type;
  }

  @Override
    RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx) {
    RuntimeValue exprValue = this.expr.eval(ctx, dynCtx);

    CallableIdent ident = mkUnaryOpCallableIdent(this.op, this.expr.type);
    CallableDefinition callable = ctx.callables.get(ident);

    return callable.eval(ctx, dynCtx, Arrays.asList(new RuntimeValue[] { exprValue }));
  }
}

class BinaryOpExpr extends Expr {
  final String op;
  final Expr left;
  final Expr right;
  BinaryOpExpr (String op, Expr left, Expr right, int begin, int end) {
    super(begin, end);
    this.op = op;
    this.left = left;
    this.right = right;
  }

  @Override
    void staticCheck(StaticContext ctx, int blockDepth) {
    this.left.staticCheck(ctx, blockDepth);
    this.right.staticCheck(ctx, blockDepth);

    CallableIdent ident = mkBinaryOpCallableIdent(this.op, this.left.type, this.right.type);
    if (!ctx.callables.containsKey(ident)) {
      throw new StaticCheckException("Not found binaryOp: " + ident.toString(), this.begin, this.end);
    }

    CallableDefinition callable = ctx.callables.get(ident);
    callable.additionStaticCheck(ctx, blockDepth, Arrays.asList(new Expr[] { this.left, this.right }), this.begin, this.end);
    this.type = callable.type;
  }

  @Override
    RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx) {
    RuntimeValue leftValue = this.left.eval(ctx, dynCtx);
    RuntimeValue rightValue = this.right.eval(ctx, dynCtx);

    CallableIdent ident = mkBinaryOpCallableIdent(this.op, this.left.type, this.right.type);
    CallableDefinition callable = ctx.callables.get(ident);

    return callable.eval(ctx, dynCtx, Arrays.asList(new RuntimeValue[] { leftValue, rightValue }));
  }
}

class CallFuncExpr extends Expr {
  final String name;
  final List<Expr> params;
  CallFuncExpr (String name, List<Expr> params, int begin, int end) {
    super(begin, end);
    this.name = name;
    this.params = params;
  }

  @Override
    void staticCheck(StaticContext ctx, int blockDepth) {
    List<String> paramTypes = new ArrayList();

    for (Expr param : this.params) {
      param.staticCheck(ctx, blockDepth);
      paramTypes.add(param.type);
    }

    CallableIdent ident = mkFunctionCallableIdent(this.name, paramTypes);
    if (!ctx.callables.containsKey(ident)) {
      throw new StaticCheckException("Not found function: " + ident.toString(), this.begin, this.end);
    }

    CallableDefinition callable = ctx.callables.get(ident);
    callable.additionStaticCheck(ctx, blockDepth, this.params, this.begin, this.end);
    this.type = callable.type;
  }

  @Override
    RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx) {
    List<RuntimeValue> paramValues =  new ArrayList();
    List<String> paramTypes = new ArrayList();
    for (Expr param : this.params) {
      paramValues.add(param.eval(ctx, dynCtx));
      paramTypes.add(param.type);
    }

    CallableIdent ident = mkFunctionCallableIdent(this.name, paramTypes);
    CallableDefinition callable = ctx.callables.get(ident);

    return callable.eval(ctx, dynCtx, paramValues);
  }
}
