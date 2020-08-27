class Ball {
  final BallConfig config;

  PVector point;
  PVector v;
  Color c;
  float r;
  float life;

  Ball(BallConfig config) {
    this.config = config;

    this.point = new PVector(0, 0, 0);
    this.v = config.v0.copy();
    this.c = config.c0;
    this.r = config.r0;
    this.life = config.life;
  }

  void update() {
    this.point = this.point.copy().add(this.v.copy().mult(SPF));
    this.v = this.v.copy().add(this.config.acc.copy().mult(SPF));
    this.c = this.c.add(this.config.dc.mult(SPF));
    this.r += this.config.dr * SPF;
    this.life -= SPF;
  }

  void draw() {
    fill((int)(this.c.r * 255), (int)(this.c.g * 255), (int)(this.c.b * 255), (int)(this.c.a * 255));
    pushMatrix();
    translate(this.point.x, this.point.y, this.point.z);
    sphere(this.r);
    popMatrix();
  }

  boolean isActive() {
    return this.life >= 0;
  }
}