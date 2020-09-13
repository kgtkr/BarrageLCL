// 参考: http://titech-ssr.blog.jp/archives/1047616866.html
class CameraController {
  final PVector EYE = new PVector(0, 0, 500);
  PMatrix3D matrix;
  CameraController() {
    this.matrix = new PMatrix3D();
  }
  void draw() {
    camera(this.EYE.x, this.EYE.y, this.EYE.z, 0, 0, 0, 0, 1, 0);
    applyMatrix(this.matrix);
  }
  void mousePressed() {
    if (mouseButton == RIGHT) {
      this.matrix.reset();
    }
  }
  void mouseDragged() {
    if (!isAlt && mouseButton == LEFT) {
      PVector prevMousePoint3d = to3dPoint(new PVector(pmouseX, pmouseY));
      PVector mousePoint3d = to3dPoint(new PVector(mouseX, mouseY));
      PVector axis = prevMousePoint3d.cross(mousePoint3d);
      float angle = PVector.angleBetween(mousePoint3d, prevMousePoint3d);
      // 何故かrotateは右から回転行列を掛けるので左から掛ける
      PMatrix3D rotate = new PMatrix3D();
      rotate.rotate(angle, axis.x, axis.y, axis.z);
      this.matrix.preApply(rotate);
    }

    if ((isAlt && mouseButton == LEFT) || mouseButton == CENTER) {
      PMatrix3D translate = new PMatrix3D();
      translate.translate(mouseX - pmouseX, mouseY - pmouseY);
      this.matrix.preApply(translate);
    }
  }
  void mouseWheel(MouseEvent event) {
    this.matrix.scale(exp(-event.getCount() / 30.0));
  }

  PVector getPoint() {
    PMatrix3D matrix = new PMatrix3D();
    matrix.set(this.matrix);
    matrix.invert();
    PVector result = new PVector();
    return matrix.mult(this.EYE, result);
  }
}

// 画面上の2d座標を3d座標に変換する
// 3d座標はスクリーンを覆う球上の座標
PVector to3dPoint(PVector screenPoint) {
  screenPoint = screenPoint.copy();
  float r = max(width, height) / 2;
  screenPoint.x = (screenPoint.x - width / 2) / r;
  screenPoint.y = (screenPoint.y - height / 2) / r;
  screenPoint.z = sqrt(max(0, 1.0 - screenPoint.magSq()));

  return screenPoint;
}
