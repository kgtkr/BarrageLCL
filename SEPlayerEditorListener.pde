import processing.sound.*;


class SEPlayerEditorListener extends EditorListener {
  SoundFile enter;
  SoundFile input;
  SoundFile move;
  SoundFile moveFail;
  SoundFile remove;

  SEPlayerEditorListener(PApplet app) {
    this.enter = new SoundFile(app, "se/enter.mp3");
    this.input = new SoundFile(app, "se/input.mp3");
    this.move = new SoundFile(app, "se/move.mp3");
    this.moveFail = new SoundFile(app, "se/moveFail.mp3");
    this.remove = new SoundFile(app, "se/remove.mp3");
  }

  @Override
    void cursorMove() {
    this.move.play();
  }

  @Override
    void cursorMoveFail() {
    this.moveFail.play();
  }

  @Override
    void inputChar() {
    this.input.play();
  }

  @Override
    void removeChar() {
    this.remove.play();
  }

  @Override
    void insertIndent() {
    this.input.play();
  }

  @Override
    void insertLine() {
    this.enter.play();
  }
}
