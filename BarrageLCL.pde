/*
左クリックドラッグ 回転
 ホイールクリックドラッグ 平行移動
 右クリック 位置リセット
 スクロール 拡大縮小
 スペース 軸表示
 esc 編集切り替え
 */

boolean isCtrl;
boolean isCmd;
boolean isAlt;
boolean isShift;
final int WINDOW_WIDTH = 1200;
final int WINDOW_HEIGHT = 800;
final int FPS = 60;
final float SPF = 1.0 / FPS;

CameraController cameraController = new CameraController();

boolean showAxis = false;
boolean editMode = false;
CodeEditor editor;
Runner runner;
DSLAnalyzer analyzer;
void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, P3D);
}

void setup() {
  noStroke();
  lights();
  hint(ENABLE_KEY_REPEAT);

  StaticContext ctx = makeStaticContext();

  runner = new Runner(this, ctx);
  analyzer = new DSLAnalyzer(runner, ctx);
  editor = new CodeEditor();
  editor.codeAnalyzer = analyzer;
  editor.editorListener = new SEPlayerEditorListener(this);

  String sample = readFileAll("sample.txt");
  editor.setText(sample);
}

void draw() {
  runner.update();

  if (frameCount % 2 != 0) {
    return;
  }
  // =====

  hint(ENABLE_DEPTH_TEST);
  background(0, 0, 0);

  cameraController.draw();
  PVector cameraPoint = cameraController.getPoint();

  if (showAxis) {
    strokeWeight(2);
    stroke(255, 0, 0);
    line(0, 0, 0, 300, 0, 0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 300, 0);
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, 300);
    noStroke();
  }

  runner.draw(cameraPoint);


  // ===
  camera();
  hint(DISABLE_DEPTH_TEST);
  if (editMode) {
    editor.draw(WINDOW_WIDTH, WINDOW_HEIGHT);
  }
}

void mousePressed() {
  cameraController.mousePressed();
}

void mouseDragged() {
  cameraController.mouseDragged();
}

void mouseWheel(MouseEvent event) {
  cameraController.mouseWheel(event);
}

void keyPressed() {
  if (keyCode == CONTROL) {
    isCtrl = true;
  }

  if (keyCode == 157) {
    isCmd = true;
  }

  if (keyCode == ALT) {
    isAlt = true;
  }

  if (keyCode == SHIFT) {
    isShift = true;
  }

  if (editMode) {
    boolean isQuit = editor.keyPressed();
    if (isQuit) {
      editMode = false;
    }
  } else {
    if (key == ESC) {
      editMode = true;
    } else if (key == ' ') {
      showAxis = !showAxis;
    }
  } 



  if (key == ESC) {
    key = 0;
  }
}


void keyTyped() {
  if (editMode) {
    editor.keyTyped();
  }
}

void keyReleased() {
  if (keyCode == CONTROL) {
    isCtrl = false;
  }

  if (keyCode == 157) {
    isCmd = false;
  }

  if (keyCode == ALT) {
    isAlt = false;
  }

  if (keyCode == SHIFT) {
    isShift = false;
  }
} 
