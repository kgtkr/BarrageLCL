class Color {
  final float r;
  final float g;
  final float b;
  final float a;

  Color(float r, float g, float b, float a) {
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }

  Color add(Color c) {
    return new Color(this.r + c.r, this.g + c.g, this.b + c.b, this.a + c.a);
  }

  Color mult(float x) {
    return new Color(this.r * x, this.g * x, this.b * x, this.a * x);
  }
}