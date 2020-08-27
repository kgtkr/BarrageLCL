class BallConfig {
  final PVector v0;
  final PVector acc;
  final Color c0;
  final Color dc;
  final float r0;
  final float dr;
  final float life;

  BallConfig(
    PVector v0, 
    PVector acc, 
    Color c0, 
    Color dc, 
    float r0, 
    float dr, 
    float life
    ) {
    this.v0 = v0;
    this.acc = acc;
    this.c0 = c0;
    this.dc = dc;
    this.r0 = r0;
    this.dr = dr;
    this.life = life;
  }

  BallConfig withV0(PVector v0) {
    return new BallConfig(v0, this.acc, this.c0, this.dc, this.r0, this.dr, this.life);
  }

  BallConfig withAcc(PVector acc) {
    return new BallConfig(this.v0, acc, this.c0, this.dc, this.r0, this.dr, this.life);
  }

  BallConfig withC0(Color c0) {
    return new BallConfig(this.v0, this.acc, c0, this.dc, this.r0, this.dr, this.life);
  }

  BallConfig withDc(Color dc) {
    return new BallConfig(this.v0, this.acc, this.c0, dc, this.r0, this.dr, this.life);
  }

  BallConfig withR0(float r0) {
    return new BallConfig(this.v0, this.acc, this.c0, this.dc, r0, this.dr, this.life);
  }

  BallConfig withDr(float dr) {
    return new BallConfig(this.v0, this.acc, this.c0, this.dc, this.r0, dr, this.life);
  }

  BallConfig withLife(float life) {
    return new BallConfig(this.v0, this.acc, this.c0, this.dc, this.r0, this.dr, life);
  }
}