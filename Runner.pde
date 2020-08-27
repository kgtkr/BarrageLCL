import java.util.function.Predicate;

class Runner {
  ArrayList<Ball> balls = new ArrayList<Ball>();
  StaticContext ctx;
  Program program;
  int frameCount = 0;
  SoundFile shotSound;
  final int MAX_BALL = 500;

  Runner(PApplet app, StaticContext ctx) {
    this.ctx = ctx;
    this.shotSound = new SoundFile(app, "se/shot.mp3");
  }

  void applyProgram(Program program) {
    this.frameCount = 0;
    this.program = program;
  }

  void update() {
    DynamicContext dynCtx = this.program.eval(this.ctx, this.frameCount);
    if (dynCtx.playSound) {
      this.shotSound.play();
    }
    for (BallConfig ball : dynCtx.balls) {
      this.balls.add(new Ball(ball));
    }
    this.frameCount++;

    for (Ball ball : this.balls) {
      ball.update();
    }

    this.balls.removeIf(new Predicate<Ball>() {
      @Override
        public boolean test(Ball ball) {
        return !ball.isActive();
      }
    }
    );
    this.balls.subList(0, Math.max(0, this.balls.size() - MAX_BALL)).clear();
  }

  void draw(PVector cameraPoint) {
    FloatDict dict = new FloatDict();
    for (int i = 0; i < this.balls.size(); i++) {
      Ball ball = this.balls.get(i);
      dict.set(str(i), cameraPoint.dist(ball.point) - ball.r);
    }
    dict.sortValuesReverse();

    for (String si : dict.keyArray()) {
      int i = int(si);
      this.balls.get(i).draw();
    }
  }
}
