
class DynamicException extends RuntimeException {
  DynamicException(String msg) {
    super(msg);
  }
}

class DynamicError {
  final String msg;
  final int begin;
  final int end;

  DynamicError(String msg, int begin, int end) {
    this.msg = msg;
    this.begin = begin;
    this.end = end;
  }
}

class DynamicContext {
  final int frameCount;
  List<BallConfig> ballStack;
  List<Integer> countStack;
  List<BallConfig> balls;
  boolean playSound;
  List<String> debugs;
  List<DynamicError> errors;

  DynamicContext (int frameCount) {
    this.frameCount = frameCount;
    this.ballStack = new ArrayList();
    this.ballStack.add(
      new BallConfig(
      new PVector(100, 0, 0), 
      new PVector(0, 0, 0), 
      new Color(1, 1, 1, 1), 
      new Color(0, 0, 0, 0), 
      10, 
      0, 
      10
      )
      );
    this.countStack = new ArrayList();
    this.balls = new ArrayList();
    this.playSound = false;
    this.debugs = new ArrayList();
    this.errors = new ArrayList();
  }
}
