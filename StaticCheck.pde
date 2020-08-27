import java.util.Objects;
import java.util.Map;
import java.util.HashMap;

enum CallableIdentKind {
  Variable, 
    Function, 
    BinaryOp, 
    UnaryOp,
}

CallableIdent mkVariableCallableIdent(String name) {
  return new CallableIdent(CallableIdentKind.Variable, name, null);
}

CallableIdent mkFunctionCallableIdent(String name, List<String> params) {
  return new CallableIdent(CallableIdentKind.Function, name, params);
}

CallableIdent mkBinaryOpCallableIdent(String name, String a, String b) {
  return new CallableIdent(CallableIdentKind.BinaryOp, name, Arrays.asList(new String[] { a, b }));
}

CallableIdent mkUnaryOpCallableIdent(String name, String a) {
  return new CallableIdent(CallableIdentKind.UnaryOp, name, Arrays.asList(new String[] { a }));
}

class CallableIdent {
  final CallableIdentKind kind;
  final String name;
  // kindがVariableの時null。BinaryOpの時長さ2、UnaryOpの時長さ1
  final List<String> params;

  private CallableIdent (CallableIdentKind kind, String name, List<String> params) {
    this.kind = kind;
    this.name = name;
    this.params = params;
  }

  @Override
    String toString() {
    switch (this.kind) {
    case Variable: 
      {
        return this.name;
      }
    case Function: 
      {
        return this.name + "(" + String.join(", ", this.params) + ")";
      }
    case BinaryOp: 
      {
        return this.params.get(0) + " " + this.name + " " + this.params.get(1);
      }
    case UnaryOp: 
      {
        return this.name + this.params.get(0);
      }
    default: 
      {
        throw new RuntimeException("unreachable");
      }
    }
  }

  @Override
    boolean equals(Object b) {
    if (!(b instanceof CallableIdent)) {
      return false;
    }

    CallableIdent other = (CallableIdent)b;

    return Objects.equals(this.kind, other.kind) &&  Objects.equals(this.name, other.name) && Objects.equals(this.params, other.params);
  }

  @Override
    int hashCode() {
    return Objects.hash(this.kind, this.name, this.params);
  }
}


class CmdIdent {
  final boolean hasBlock;
  final String name;
  final List<String> params;

  CmdIdent (boolean hasBlock, String name, List<String> params) {
    this.hasBlock = hasBlock;
    this.name = name;
    this.params = params;
  }

  @Override
    String toString() {
    String res = this.name + " " +  String.join(" ", this.params);
    if (this.hasBlock) {
      res += " { ... }";
    }

    return res;
  }

  @Override
    boolean equals(Object b) {
    if (!(b instanceof CmdIdent)) {
      return false;
    }

    CmdIdent other = (CmdIdent)b;

    return Objects.equals(this.hasBlock, other.hasBlock) && Objects.equals(this.name, other.name) && Objects.equals(this.params, other.params);
  }

  @Override
    int hashCode() {
    return Objects.hash(this.hasBlock, this.name, this.params);
  }
}

class StaticCheckException extends RuntimeException {
  final int begin;
  final int end;

  StaticCheckException(String msg, int begin, int end) {
    super(msg);
    this.begin = begin;
    this.end = end;
  }
}

// コマンド
abstract class CmdDefinition {
  final CmdIdent ident; 

  CmdDefinition (CmdIdent ident) {
    this.ident = ident;
  }

  abstract void eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params, List<Cmd> block, boolean createCtx);

  // 追加の静的チェック
  void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, List<Cmd> block, int begin, int end) {
  }

  // ループするコマンドはこれを追加
  int loopCount(List<Expr> params) {
    return 1;
  }
}

// 単項演算子、変数、二項演算子も関数呼び出しと同じ扱い
abstract class CallableDefinition {
  final CallableIdent ident;
  final String type;

  CallableDefinition (CallableIdent ident, String type) {
    this.ident = ident;
    this.type = type;
  }

  abstract RuntimeValue eval(StaticContext ctx, DynamicContext dynCtx, List<RuntimeValue> params);

  // 追加の静的チェック
  void additionStaticCheck(StaticContext ctx, int blockDepth, List<Expr> params, int begin, int end) {
  }
}

final String FLOAT_TYPE_NAME = "float";
final String VEC_TYPE_NAME = "vec";
final String COLOR_TYPE_NAME = "color";

abstract class RuntimeValue {
}

class FloatValue extends RuntimeValue {
  final float value;
  FloatValue(float value) {
    this.value = value;
  }
}

class VecValue extends RuntimeValue {
  final PVector value;
  VecValue(PVector value) {
    this.value = value;
  }
}

class ColorValue extends RuntimeValue {
  final Color value;
  ColorValue(Color value) {
    this.value = value;
  }
}

class StaticContext {
  Map<CmdIdent, CmdDefinition> cmds;
  Map<CallableIdent, CallableDefinition> callables;

  StaticContext () {
    this.cmds = new HashMap();
    this.callables = new HashMap();
  }

  void addCmd(CmdDefinition cmd) {
    this.cmds.put(cmd.ident, cmd);
  }

  void addCallable(CallableDefinition callable) {
    this.callables.put(callable.ident, callable);
  }
}
