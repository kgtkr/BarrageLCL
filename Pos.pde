class Pos {
  final int line;
  final  int col;

  // 行を無視したposをsrcから変換
  Pos(String src, int pos) {
    int line = 0;
    int col = 0;
    for (int i = 0; i < pos; i++) {
      if (src.length() > i && src.charAt(i) == '\n') {
        col = 0;
        line++;
      } else {
        col++;
      }
    }

    this.line = line;
    this.col = col;
  }

  Pos(int line, int col) {
    this.line = line;
    this.col = col;
  }
}
